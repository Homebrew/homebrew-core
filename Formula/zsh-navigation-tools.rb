class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.1.4.tar.gz"
  sha256 "3071d12e0982dcf7dbaaf7c3cd546de60c53eabe8f3ea09a0ece0b26db80515b"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb7b187e5fb0a5584ad8b84b76e2f178e6fbd9a02a8e6bd620f2fe7aac270142" => :el_capitan
    sha256 "6c9cba4adb4eae367402da1a5e86a363c1e9e776c1fd908c3779af8605241744" => :yosemite
    sha256 "44ae9be2e3bb71cd880de68e512911fc26a2c4d1e28aa127e1396fb0645a6fc0" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    To run zsh-navigation-tools, add the following at the end of your .zshrc:
      fpath+=( #{HOMEBREW_PREFIX}/share/zsh-navigation-tools )
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
