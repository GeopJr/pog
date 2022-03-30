# Parses CLI options

# [MACRO] Skip on spec
{% skip_file if @top_level.has_constant? "Spec" %}

require "option_parser"
require "./logger.cr"

module Pog
  Version = {{read_file("./shard.yml").split("version: ")[1].split("\n")[0]}} # [MACRO] Get pog version
  Args    = {
    "command" => "",
    "flags"   => [] of String,
    "dir"     => Path.new,
  }

  dir = Dir.current
  parser = OptionParser.new do |parser|
    parser.banner = <<-BANNER
    #{"pog v#{Version}".colorize(:light_yellow)}
    
    #{"USAGE:".colorize(:light_yellow)}
        pog [OPTIONS] COMMAND [ARGS]
    
    #{"COMMANDS:".colorize(:light_yellow)}
        <script_name>             Run a script
        run                       List available scripts
        run <script_name>         Same as <script_name>
        add <packages>            Same as (p)npm i or yarn add <packages>
        i, install                Same as (p)npm/yarn install
        remove, uninstall         Same as (p)npm/yarn remove
    
    #{"FLAGS:".colorize(:light_yellow)}
    BANNER
    parser.on("-c INPUT", "--cd=INPUT", "Change working directory") do |input|
      dir = input
      unless Dir.exists?(dir)
        Pog::Logger.fatal("Directory \"#{dir}\" does not exist")
      end
    end
    parser.on("-h", "--help", "Show this help") do
      puts parser
      exit
    end
    # Everything that doesn't fit the above
    parser.unknown_args do |args|
      Pog::Logger.fatal("Command/Script missing") if args.size == 0
      Args["command"] = args[0]
      Args["flags"] = args[1..-1] if args.size > 1
    end
    parser.invalid_option { }
  end

  parser.parse
  # Set dir as the expanded of current or input
  Args["dir"] = Path[dir].expand
end
