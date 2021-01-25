class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting.git",
      tag:      "0.7.1",
      revision: "932e29a0c75411cb618f02995b66c0a4a25699bc"
  license "BSD-3-Clause"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0f75f5893a2179a2b1990bfb1a8e28ff3cf312dde3e11504504e9c32aed91725" => :big_sur
    sha256 "aebae47a0461de83530eb59106818889fc1a1a0e3cec2ddcefe629c3c8c172bd" => :arm64_big_sur
    sha256 "8b240a93c28b0c190c427afee55b80a0195dc0ed0cdb2ec956871330e0b2f3a5" => :catalina
    sha256 "ab57b09a3770c0497b1704ca86bbd285d9bcab439316c0bd7f72ab72e8597d92" => :mojave
    sha256 "f8e941c6208a3b895a174be341a9ef2c114a3d5efeb0e86b421825b2aee0b943" => :high_sierra
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
