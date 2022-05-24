class Syntaxerl < Formula
  desc "Syntax checker for Erlang code and config files"
  homepage "https://github.com/ten0s/syntaxerl"
  url "https://github.com/ten0s/syntaxerl/archive/0.15.0.tar.gz"
  sha256 "61d2d58e87a7a5eab1f58c5857b1a9c84a091d18cd683385258c3c0d7256eb64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b345b0ceabb3e230634ef5f9d8fe3bfee1500f94dc94a79b504bbf6173a6758"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab2fde926ac270aa052a969bef6b5a41deed043b9ca49255c77f6d4ec94d9041"
    sha256 cellar: :any_skip_relocation, monterey:       "a534cfe8a626f0021cbb59bc36be178167b074b8305d4d56b7e38b6501735cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba352469157bac0b0645fc0a2cfc1ec738487e2fbf3f6e9c5842c8ce9d4e5a0c"
    sha256 cellar: :any_skip_relocation, catalina:       "1d83b5507f1a4f1ac6ae3a09ae41056ab6588caab3d0737ac3707384faa45770"
    sha256 cellar: :any_skip_relocation, mojave:         "b2b5d4afd0e7f5e4feb748dc7cc738f65612cb06e4f09a59f7b8f3fdcbb4c424"
    sha256 cellar: :any_skip_relocation, high_sierra:    "81bba7402fee8403b05bef71b2552e65303b0a4399c7465d5c653fdab659fb9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e47e3fbad8b97527b59bf69db9d9d765e04352e6a408827bd995091f6400f65"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install "_build/default/bin/syntaxerl"
  end

  test do
    (testpath/"app.config").write "[{app,[{arg1,1},{arg2,2}]}]."
    assert_equal "",
      shell_output("#{bin}/syntaxerl #{testpath}/app.config")

    (testpath/"invalid.config").write "]["
    assert_match "invalid.config:1: syntax error before: ']'",
      shell_output("#{bin}/syntaxerl #{testpath}/invalid.config", 1)
  end
end
