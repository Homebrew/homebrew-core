class ZshFSyH < Formula
  desc "Feature-rich Syntax Highlighting for Zsh"
  homepage "https://wiki.zshell.dev/search?q=F-Sy-H"
  url "https://github.com/z-shell/F-Sy-H/archive/refs/tags/v1.67.1.tar.gz"
  sha256 "303e515618c2be95781ef86ac7b018da95aa874a59a4c7e7c721f43c310125fb"
  license "BSD-3-Clause"
  head "https://github.com/z-shell/F-Sy-H.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f111e49b0f927b08af4194279c39a9191cd8ba6738fe8392fed01f4bb41bd47"
  end

  uses_from_macos "zsh" => :test

  deny_network_access!

  def install
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate the syntax highlighting, add the following at the end of your .zshrc:
        source #{HOMEBREW_PREFIX}/share/zsh-f-sy-h/F-Sy-H.plugin.zsh
    EOS
  end

  test do
    assert_match "#{version}\n",
      shell_output("zsh -c '. #{pkgshare}/F-Sy-H.plugin.zsh && echo $FAST_HIGHLIGHT_VERSION'")
  end
end
