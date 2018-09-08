class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting.git",
      :tag => "0.6.0",
      :revision => "434af7b11dd33641231f1b48b8432e68eb472e46"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b91cbda8cbfe4a089ded8cefa4f6e06ad0946851b8fdda7617ab76bb4f5e50" => :mojave
    sha256 "97dc3e73da8e3a8cb054a780a28cda23be2bbd33547daa606d71a3c7f1d2821f" => :high_sierra
    sha256 "34fff5bf9bcacd1aaf3aad77199fc61a5ca31239236adaef0bab92452b5b4ad3" => :sierra
    sha256 "34fff5bf9bcacd1aaf3aad77199fc61a5ca31239236adaef0bab92452b5b4ad3" => :el_capitan
    sha256 "34fff5bf9bcacd1aaf3aad77199fc61a5ca31239236adaef0bab92452b5b4ad3" => :yosemite
  end

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
