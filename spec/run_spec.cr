require "./spec_helper"

describe Pog::Run do
  it "runs a command" do
    file = Pog::SPEC_FOLDER.join("random.txt")
    Pog::Run.command("touch", [file.to_s])
    File.exists?(file).should eq(true)
    File.delete(file)
  end

  it "gets a list of binary paths" do
    Pog::Args["dir"] = Pog::SPEC_FOLDER
    # [MACRO] Deep-search
    {% if !env("POG_ENABLE_DEEPSEARCH").nil? && env("POG_ENABLE_DEEPSEARCH").downcase == "true" %}
      paths = Pog::Run.bin_paths.split(":")
      paths.should contain("#{Pog::SPEC_FOLDER.join("node_modules", "sveltepress-ui", ".bin")}")
      paths.should contain("#{Pog::SPEC_FOLDER.join("node_modules", "create-sveltepress-app", "bin")}")
    {% else %}
      Pog::Run.bin_paths.should eq(Pog::SPEC_FOLDER.join("node_modules", ".bin"))
    {% end %}
  end

  it "runs the selected script" do
    Pog::Args["dir"] = Pog::SPEC_FOLDER
    Pog::Args["command"] = "test"

    Pog::Run.run
    File.exists?(Pog::SPEC_FOLDER.join("random.yaml")).should eq(true)
  end

  it "runs an executable" do
    Pog::Args["dir"] = Pog::SPEC_FOLDER
    Pog::Args["command"] = "csa"

    Pog::Run.run
    File.exists?(Pog::SPEC_FOLDER.join("random.json")).should eq(true)
  end
end
