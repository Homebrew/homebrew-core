class ZshFSyH < Formula
  desc "Feature-rich Syntax Highlighting for Zsh"
  homepage "https://wiki.zshell.dev/search?q=F-Sy-H"
  url "https://github.com/z-shell/F-Sy-H/archive/refs/tags/v1.67.tar.gz"
  sha256 "4d8b112b326843443fbbbeb9d8c0694b57c331b91ca6bb1d5f67750f3254e6f5"
  license "BSD-3-Clause"
  head "https://github.com/z-shell/F-Sy-H.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "471a7ee20877bec72b47a50515a8cab4b768ff09ad72560d3d0647a6d0a94be1"
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
