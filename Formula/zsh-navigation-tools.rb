class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.2.4.tar.gz"
  sha256 "dd1a999c2fa5e62491cc1be7745e2c7a1cde6338f9c577bf8c7cec9decdc6243"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba95499ec391cce120175fe1a27d49f5169576f306af16adb2e6e38d2d930672" => :sierra
    sha256 "ba95499ec391cce120175fe1a27d49f5169576f306af16adb2e6e38d2d930672" => :el_capitan
    sha256 "ba95499ec391cce120175fe1a27d49f5169576f306af16adb2e6e38d2d930672" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    To run zsh-navigation-tools, add the following at the end of your .zshrc:
      source #{HOMEBREW_PREFIX}/share/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh

    You will also need to force reload of your .zshrc:
      source ~/.zshrc
    EOS
  end

  test do
    # This compiles package's main file
    # Zcompile is very capable of detecting syntax errors
    cp pkgshare/"n-list", testpath
    system "zsh", "-c", "zcompile n-list"
  end
end
