class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.1.11.tar.gz"
  sha256 "a14c2218bdea29287c434b871b274fed3bb0cdc270714f7eac3bd80e94969732"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc6590d03f7196934c95187170b204c598556bdc2a12d13584729b9a850f4f74" => :el_capitan
    sha256 "c341a37ffd94e1a254976ea7d8fe09844462d7a9bbb733dda566318e2c999c57" => :yosemite
    sha256 "4b3fccc1912c20948ca9ccd5828b6b622d163478c93f450af91fa35b87e5f06b" => :mavericks
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
