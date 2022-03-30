# Responsible for running the scripts

require "json"
require "./pm.cr"

module Pog::Run
  extend self

  # Commands to be forwarded to package manager
  NB = ["install", "add", "remove", "i", "uninstall"]

  # Command runner that accepts env vars
  def command(cmd : String, args : Array(String), env : Hash(String, String?) = ENV.to_h, cd : Path = Args["dir"].as(Path))
    # Change dir to the set one prior to running
    Dir.cd(cd) unless Dir.current == cd.to_s
    # [MACRO] In spec use Process#run as we need to return, but in normal use Process#exec
    {% if @top_level.has_constant? "Spec" %}
      Process.run(cmd, args: args, env: env, output: Process::Redirect::Inherit, error: Process::Redirect::Inherit)
    {% else %}
      Process.exec(cmd, args: args, env: env, output: Process::Redirect::Inherit, error: Process::Redirect::Inherit)
    {% end %}
  end

  # [MACRO] If you pass POG_ENABLE_DEEPSEARCH=true on compile-time, the following function will be enabled
  # it searches all node_modules for their bin folders. Usually your package manager puts them all in ".bin",
  # however sometimes the dependencies either are built wrong or don't "export" them for reasons.
  {% if !env("POG_ENABLE_DEEPSEARCH").nil? && env("POG_ENABLE_DEEPSEARCH").downcase == "true" %}
    def deep_find_bins(path : Path = Args["dir"].as(Path).join("node_modules"), max_depth : Int32 = -1, top : Bool = true) : Array(Path)
      result = [] of Path
      return result if max_depth == 0

      allowed_paths = [path.join(".bin"), path.join("bin")]
      Dir.open(path).each_child do |child|
        new_path = path.join(child)
        if Dir.exists?(new_path) && child != ".pnpm"
          if allowed_paths.includes?(new_path) && !top
            result << new_path
          else
            result = result + deep_find_bins(new_path, max_depth - 1, false)
          end
        end
      end
      result
    end
  {% end %}

  # Returns the path(s) of tghe binaries
  def bin_paths
    # [MACRO] Use deep-search if enabled
    {% if !env("POG_ENABLE_DEEPSEARCH").nil? && env("POG_ENABLE_DEEPSEARCH").downcase == "true" %}
      "#{deep_find_bins.join(":")}"
    {% else %}
      Args["dir"].as(Path).join("node_modules", ".bin")
    {% end %}
  end

  def run
    command_name = Args["command"].as(String)
    args = Args["flags"].as(Array(String))

    # If should be forwarded to PM
    if NB.includes?(command_name)
      pm = Pog::Pm.guess_pm.to_s.downcase
      # yarn restricts to "add", npm to "install" and pnpm uses both
      if command_name == "add" && pm != "yarn"
        command_name = "install"
      elsif command_name == "install" && pm == "yarn"
        command_name = "add"
      end

      command(pm, args.push(command_name))
    else
      dir = Args["dir"].as(Path)
      pkg = dir.join("package.json")
      # Check if package.json exists
      Pog::Logger.fatal("package.json not found") unless File.exists?(pkg)

      # Get scripts
      package = JSON.parse(File.read(pkg)).as_h
      scripts = package.has_key?("scripts") ? package["scripts"].as_h : nil
      # Add the bin paths to path env var so it can be accessed when running
      # commands
      new_env = ENV.to_h
      new_env["PATH"] = new_env["PATH"] + ":#{bin_paths}"

      Pog::Logger.status(command_name, true)
      # If there are no scripts or the script is missing
      if scripts.nil? || !scripts.has_key?(command_name)
        # Search for the executable in dir
        bin_path = Process.find_executable(command_name, "#{bin_paths}", dir)

        Pog::Logger.fatal("Script or executable \"#{command_name}\" not found") if bin_path.nil?
        Pog::Logger.status(bin_path)

        command(bin_path, args, new_env)
      else # If the script was found
        Pog::Logger.status("#{scripts[command_name]}")
        # Run it
        command("sh", ["-c", "#{scripts[command_name]} #{args.join(" ")}"], new_env)
      end
    end
  end
end
