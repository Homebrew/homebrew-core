class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/tags/0.8.0.tar.gz"
  sha256 "5981c19ebaab027e356fe1ee5284f7a021b89d4405cc53dc84b476c3aee9cc32"
  license "BSD-3-Clause"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3cfaa693dab68d9a576ad1ad0a018e12b250a057963263733f6fcc9b4c4ce8a6"
  end

  uses_from_macos "zsh" => [:build, :test]

  def install
    # Make the bottles uniform (modifying a comment with /usr/local path)
    inreplace "highlighters/main/main-highlighter.zsh", "/usr/local/bin", "#{HOMEBREW_PREFIX}/bin"

    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<~EOS
      To activate the syntax highlighting, add the following at the end of your .zshrc:
        source #{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      If you receive "highlighters directory not found" error message,
      you may need to add the following to your .zshenv:
        export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=#{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters
    EOS
  end

  test do
    assert_match "#{version}\n",
      shell_output("zsh -c '. #{pkgshare}/zsh-syntax-highlighting.zsh && echo $ZSH_HIGHLIGHT_VERSION'")
  end
end
