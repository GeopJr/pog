require "spec"
require "file_utils"
require "../src/pog/*"

# Prepare the spec by creating folders in /tmp
module Pog
  Args = {
    "command" => "",
    "flags"   => [] of String,
    "dir"     => Path[Dir.current].expand,
  }
  SPEC_FOLDER = Path[Dir.tempdir, "pog_spec"]
  FileUtils.rm_rf(SPEC_FOLDER)

  NODE_MODULES = SPEC_FOLDER.join("node_modules")
  Dir.mkdir_p(NODE_MODULES.join(".bin"))

  SVELTEPRESS_BIN = NODE_MODULES.join("create-sveltepress-app", "bin")
  Dir.mkdir_p(SVELTEPRESS_BIN)
  Dir.mkdir_p(SVELTEPRESS_BIN.join("..", "..", "sveltepress-ui", ".bin"))
  File.write(SVELTEPRESS_BIN.join("csa"), "#!/bin/sh\n\ntouch random.json")
  File.chmod(SVELTEPRESS_BIN.join("csa"), File::Permissions::All)
  File.symlink(SVELTEPRESS_BIN.join("csa"), NODE_MODULES.join(".bin", "csa"))

  File.write(Pog::SPEC_FOLDER.join("package.json"), "{\"scripts\": {\"test\": \"touch random.yaml\"}}")
end
