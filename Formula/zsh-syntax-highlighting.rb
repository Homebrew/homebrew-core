class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting/archive/0.4.1.tar.gz"
  sha256 "971b9c1e881a8d60442e40003c9e4c98bd1d5243a32fdf386a217c4cd7815197"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "96a78e71b1863e90d393aa4e5d4f4c9632a9fccd5502026c8a5d38692804305a" => :el_capitan
    sha256 "51d52d71796737c9386386cd614830bb4b786316413fdba6ee21425bc1e15f74" => :yosemite
    sha256 "2c7a792630e51a3283f9dc4f5785f1d8a812cfa0bd78a3d26c4e0ac473391302" => :mavericks
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
