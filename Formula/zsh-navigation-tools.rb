class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.2.2.tar.gz"
  sha256 "5909c808e446a50ab0363dae88b8631c4c0f4c01ef00c2d61d785608cfcc7a90"

  bottle do
    cellar :any_skip_relocation
    sha256 "dce65bfad21877d8f1c6922a306679f7508dfa386eee555f9e36803d0d6b2d9c" => :sierra
    sha256 "dce65bfad21877d8f1c6922a306679f7508dfa386eee555f9e36803d0d6b2d9c" => :el_capitan
    sha256 "dce65bfad21877d8f1c6922a306679f7508dfa386eee555f9e36803d0d6b2d9c" => :yosemite
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
