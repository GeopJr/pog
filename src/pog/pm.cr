# Responsible for detecting the package manager based on its lockfile

require "./args.cr"

module Pog::Pm
  extend self

  enum PackageManager
    Npm
    Pnpm
    Yarn
  end

  Locks = {
    "package-lock.json": PackageManager::Npm,
    "pnpm-lock.yaml":    PackageManager::Pnpm,
    "yarn.lock":         PackageManager::Yarn,
  }

  def guess_pm(path : Path = Pog::Args["dir"].as(Path)) : PackageManager | Nil
    Locks.each do |lock, pm|
      return pm if File.exists?(path.join(lock))
    end
  end
end
