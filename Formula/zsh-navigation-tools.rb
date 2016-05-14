class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.1.11.tar.gz"
  sha256 "a14c2218bdea29287c434b871b274fed3bb0cdc270714f7eac3bd80e94969732"

  bottle do
    cellar :any_skip_relocation
    sha256 "84dc711a5ed88c6a30cee1154444e7a7bb4f9fa6f5fb934ec4cf0e0760fc746f" => :el_capitan
    sha256 "01a045c21d8f266f101f3dbfc82b9ea51305f1f61e91995ef64772f5cf5db79e" => :yosemite
    sha256 "3a74796bfc9a21a23421fcd2437b68f6176c0e18b87953ce3e22e3e63d5a37e7" => :mavericks
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
