class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.0.5.tar.gz"
  sha256 "f599a36693b9bacaccdb5ce9939f5be3695b59ef5b84485f618164bb2c77fe95"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<-EOS.undent
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
