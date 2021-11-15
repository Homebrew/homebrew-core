class ZshNavigationTools < Formula
  desc "Zsh curses-based tools, e.g. multi-word history searcher"
  homepage "https://github.com/psprint/zsh-navigation-tools"
  url "https://github.com/psprint/zsh-navigation-tools/archive/v2.2.7.tar.gz"
  sha256 "ee832b81ce678a247b998675111c66aa1873d72aa33c2593a65626296ca685fc"
  license any_of: ["GPL-3.0-only", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b5a0cee362c74dd8466a9551c20bdcdcef893f0c7a461ba7ac6b69f7e2b1b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a968a06b57fd74fb842f504c30d61e8c22aa57da9f84d8aca3159f1b5c2eb284"
    sha256 cellar: :any_skip_relocation, monterey:       "cd64e2dd30707bbfe0d8d7f0c250627a185bd6fb778fa6a0dd71252c0f482c73"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a2b501900c37cc6844a700526ea564baf4585d368de2ad17ccd6679e222f317"
    sha256 cellar: :any_skip_relocation, catalina:       "2ca507bf832d34b63b9bf4f60b76158ad0e8980622f78de8fd8e3f771d4df5d2"
    sha256 cellar: :any_skip_relocation, mojave:         "292a200717412253b03f654162da7ce1c0994455c07fdf65fa348189a18217b5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5122287e2fb30bde73acb7174e1310ea41ef049d201203bc559edf02555a2e33"
    sha256 cellar: :any_skip_relocation, sierra:         "fca68610ba67c19d8516719d03ed5074a5611ba01941dcb135c87d6d561f3cb1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "fca68610ba67c19d8516719d03ed5074a5611ba01941dcb135c87d6d561f3cb1"
    sha256 cellar: :any_skip_relocation, yosemite:       "fca68610ba67c19d8516719d03ed5074a5611ba01941dcb135c87d6d561f3cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5a0cee362c74dd8466a9551c20bdcdcef893f0c7a461ba7ac6b69f7e2b1b9f"
  end

  uses_from_macos "zsh"

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
