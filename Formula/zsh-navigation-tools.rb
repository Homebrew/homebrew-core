class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.2.7.tar.gz"
  sha256 "ee832b81ce678a247b998675111c66aa1873d72aa33c2593a65626296ca685fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a2b501900c37cc6844a700526ea564baf4585d368de2ad17ccd6679e222f317" => :big_sur
    sha256 "a968a06b57fd74fb842f504c30d61e8c22aa57da9f84d8aca3159f1b5c2eb284" => :arm64_big_sur
    sha256 "2ca507bf832d34b63b9bf4f60b76158ad0e8980622f78de8fd8e3f771d4df5d2" => :catalina
    sha256 "292a200717412253b03f654162da7ce1c0994455c07fdf65fa348189a18217b5" => :mojave
    sha256 "5122287e2fb30bde73acb7174e1310ea41ef049d201203bc559edf02555a2e33" => :high_sierra
    sha256 "fca68610ba67c19d8516719d03ed5074a5611ba01941dcb135c87d6d561f3cb1" => :sierra
    sha256 "fca68610ba67c19d8516719d03ed5074a5611ba01941dcb135c87d6d561f3cb1" => :el_capitan
    sha256 "fca68610ba67c19d8516719d03ed5074a5611ba01941dcb135c87d6d561f3cb1" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
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
