class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.2.1.tar.gz"
  sha256 "3937aa4cb4a77f8c7dd161e1703db63e6d6dc18a1c4b4562ed77bb6b8b0cd144"

  bottle do
    cellar :any_skip_relocation
    sha256 "f698c058bddd1edc7ad25d8eaacdc532cbd801d4c04ba6c7fc254488f7acde30" => :el_capitan
    sha256 "7f9d81ac197f734b8f5b86f446c0ac2941c85f65a11fee2d1f5f27f2631fb72a" => :yosemite
    sha256 "c74f70154dd2301e5cc20e539c72f25db47dfa63387eb7126c0292d836aa7b15" => :mavericks
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
