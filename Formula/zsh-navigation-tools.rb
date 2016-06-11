class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.2.1.tar.gz"
  sha256 "3937aa4cb4a77f8c7dd161e1703db63e6d6dc18a1c4b4562ed77bb6b8b0cd144"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ec7607ad8b05c86891d2ef92bfbf50661e6aa156bd01916b26be1ad27ffaae0" => :el_capitan
    sha256 "5b1977fd6a3c5adaf663b6292a7bbb8edcbcd53a0377acc3422fc4d97255626b" => :yosemite
    sha256 "db2b464f57e7125fd916ba750c3d1c9ecf4cc27febb7e3c75499696c585b3601" => :mavericks
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
