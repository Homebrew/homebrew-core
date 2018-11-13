class Tmuxinator < Formula
  desc "Install Tmuxinator as Homebrew formulae"
  homepage "https://github.com/tmuxinator/tmuxinator"
  url "https://github.com/tmuxinator/tmuxinator/archive/v0.13.0.tar.gz"
  sha256 "48d2d83fa93a394fde310375c54425958934e8dc9e202902d5c4c7cb9146c151"
  head "https://github.com/tmuxinator/tmuxinator.git"

  bottle :unneeded

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "tmuxinator.gemspec"
    system "gem", "install", "tmuxinator-#{version}.gem"
    bin.install libexec/"bin/tmuxinator"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
  end

  test do
    system "#{bin}/tmuxinator", "help"
  end
end
