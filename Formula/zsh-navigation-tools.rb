class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.1.17.tar.gz"
  sha256 "eaa05b67f49bafdf5a396183365745ddf14fae138be03a63f1c5d87fd34694e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f698c058bddd1edc7ad25d8eaacdc532cbd801d4c04ba6c7fc254488f7acde30" => :el_capitan
    sha256 "7f9d81ac197f734b8f5b86f446c0ac2941c85f65a11fee2d1f5f27f2631fb72a" => :yosemite
    sha256 "c74f70154dd2301e5cc20e539c72f25db47dfa63387eb7126c0292d836aa7b15" => :mavericks
  end

  def install
    system "make", "install-brew", "PREFIX=#{prefix}"
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
