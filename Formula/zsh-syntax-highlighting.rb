class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting.git",
      :tag      => "0.7.1",
      :revision => "932e29a0c75411cb618f02995b66c0a4a25699bc"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b7d4cdc41b56c842a4b76f9901d922d1f39bd638e94249881078a873de8970b" => :catalina
    sha256 "6b7d4cdc41b56c842a4b76f9901d922d1f39bd638e94249881078a873de8970b" => :mojave
    sha256 "6b7d4cdc41b56c842a4b76f9901d922d1f39bd638e94249881078a873de8970b" => :high_sierra
  end

  uses_from_macos "zsh"

  def install
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
