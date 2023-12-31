class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting.git",
      tag:      "0.8.0",
      revision: "db085e4661f6aafd24e5acb5b2e17e4dd5dddf3e"
  license "BSD-3-Clause"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "603dabae4003cd3d95ab7f872a7fd9944e67cf0d963ffe42a07c8f3c191211ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "603dabae4003cd3d95ab7f872a7fd9944e67cf0d963ffe42a07c8f3c191211ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "603dabae4003cd3d95ab7f872a7fd9944e67cf0d963ffe42a07c8f3c191211ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "78a5770992ca645e5271e2a2b9aef6d99502ff99bace3a7470020b8dc34fcb4d"
    sha256 cellar: :any_skip_relocation, ventura:        "78a5770992ca645e5271e2a2b9aef6d99502ff99bace3a7470020b8dc34fcb4d"
    sha256 cellar: :any_skip_relocation, monterey:       "78a5770992ca645e5271e2a2b9aef6d99502ff99bace3a7470020b8dc34fcb4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "603dabae4003cd3d95ab7f872a7fd9944e67cf0d963ffe42a07c8f3c191211ea"
  end

  uses_from_macos "zsh" => [:build, :test]

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
