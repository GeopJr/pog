require "./spec_helper"

describe Pog::Pm do
  it "detects the correct package manager based on lockfile" do
    Pog::Pm::Locks.each do |lock, pm|
      path = Pog::SPEC_FOLDER.join(lock)
      File.write(path, "pog")
      Pog::Pm.guess_pm(Pog::SPEC_FOLDER).should eq(pm)
      File.delete(path)
    end
  end
end
