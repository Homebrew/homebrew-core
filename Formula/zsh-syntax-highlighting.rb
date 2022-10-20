class ZshSyntaxHighlighting < Formula
  desc "Fish shell like syntax highlighting for zsh"
  homepage "https://github.com/zsh-users/zsh-syntax-highlighting"
  url "https://github.com/zsh-users/zsh-syntax-highlighting.git",
      tag:      "0.7.1",
      revision: "932e29a0c75411cb618f02995b66c0a4a25699bc"
  license "BSD-3-Clause"
  head "https://github.com/zsh-users/zsh-syntax-highlighting.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd9350c88caf637d8c8e5b036d6913952ec9ac3480d633bc346b2e5c988ec48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebae47a0461de83530eb59106818889fc1a1a0e3cec2ddcefe629c3c8c172bd"
    sha256 cellar: :any_skip_relocation, monterey:       "ce55800da8e7546b38c17e715c1497cf35069cd76d15da779ae1a12c10173e02"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f75f5893a2179a2b1990bfb1a8e28ff3cf312dde3e11504504e9c32aed91725"
    sha256 cellar: :any_skip_relocation, catalina:       "8b240a93c28b0c190c427afee55b80a0195dc0ed0cdb2ec956871330e0b2f3a5"
    sha256 cellar: :any_skip_relocation, mojave:         "ab57b09a3770c0497b1704ca86bbd285d9bcab439316c0bd7f72ab72e8597d92"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f8e941c6208a3b895a174be341a9ef2c114a3d5efeb0e86b421825b2aee0b943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "069a8cb00d623b12e284e1ee3e68adc1eea62068bf9743798a734806317e3984"
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
