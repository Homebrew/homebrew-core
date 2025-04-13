class ZshFSyH < Formula
  desc "Feature-rich Syntax Highlighting for Zsh"
  homepage "https://wiki.zshell.dev/search?q=F-Sy-H"
  url "https://github.com/z-shell/F-Sy-H/archive/refs/tags/v1.67.tar.gz"
  sha256 "4d8b112b326843443fbbbeb9d8c0694b57c331b91ca6bb1d5f67750f3254e6f5"
  license "BSD-3-Clause"
  head "https://github.com/z-shell/F-Sy-H.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "219d0141922740e742d765b4e55a3b6331cd0deaab671c07a19a085b04e2f7ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219d0141922740e742d765b4e55a3b6331cd0deaab671c07a19a085b04e2f7ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "219d0141922740e742d765b4e55a3b6331cd0deaab671c07a19a085b04e2f7ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd302983d8a9fc3a2764b8e1b1936c8b2d261193650ba5d3efa1bac506291a3b"
    sha256 cellar: :any_skip_relocation, ventura:       "cd302983d8a9fc3a2764b8e1b1936c8b2d261193650ba5d3efa1bac506291a3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "219d0141922740e742d765b4e55a3b6331cd0deaab671c07a19a085b04e2f7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "219d0141922740e742d765b4e55a3b6331cd0deaab671c07a19a085b04e2f7ef"
  end

  uses_from_macos "zsh" => :test

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
