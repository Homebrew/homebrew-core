class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting.git",
    :tag => "0.4.1",
    :revision => "c19ee583138ebab416b0d2efafbad7dc9f3f7c4f"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d0a908723170b786cb7e1fea2f3441cd6bda43e4a3d7c0f6c96125807514672f" => :sierra
    sha256 "daafc718f3fcc4907818a77895f9b02a0666638bfad8e4a3e7b781c0c4e99078" => :el_capitan
    sha256 "d0a908723170b786cb7e1fea2f3441cd6bda43e4a3d7c0f6c96125807514672f" => :yosemite
    sha256 "d0a908723170b786cb7e1fea2f3441cd6bda43e4a3d7c0f6c96125807514672f" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats
    <<-EOS.undent
    To activate the syntax highlighting, add the following at the end of your .zshrc:

      source #{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    You will also need to force reload of your .zshrc:

      source ~/.zshrc

    Additionally, if your receive "highlighters directory not found" error message,
    you may need to add the following to your .zshenv:

      export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=#{HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/highlighters
    EOS
  end

  test do
    assert_match "#{version}\n",
      shell_output("zsh -c '. #{pkgshare}/zsh-syntax-highlighting.zsh && echo $ZSH_HIGHLIGHT_VERSION'")
  end
end
