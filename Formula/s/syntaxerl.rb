class Syntaxerl < Formula
  desc "Syntax checker for Erlang code and config files"
  homepage "https://github.com/ten0s/syntaxerl"
  url "https://github.com/ten0s/syntaxerl/archive/refs/tags/0.15.0.tar.gz"
  sha256 "61d2d58e87a7a5eab1f58c5857b1a9c84a091d18cd683385258c3c0d7256eb64"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2b89005e55db2bd8c5e4f17cb921180b4795622abf46dfc4b1dd11997ceac389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "33837e94cbdb2721705f5fe69069caabf858455790d9bc7d47c2d73d8f035120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cee18e0e209e6dba8a575cf868e38cbaf37fb17d5d6d1c4bf893b73a26e8c14e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8b0d346a0d701c3146aa9c6beedf9122be2efd84112b78b05d07e45d343cb00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b345b0ceabb3e230634ef5f9d8fe3bfee1500f94dc94a79b504bbf6173a6758"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab2fde926ac270aa052a969bef6b5a41deed043b9ca49255c77f6d4ec94d9041"
    sha256 cellar: :any_skip_relocation, sonoma:         "655d5e3edb476b65f80b386a9ac7814b7b43442975915a6b8fffc17fba925b95"
    sha256 cellar: :any_skip_relocation, ventura:        "9cc0483c3b108df574160bd98eb42cbfc72567e59fdefa71dc2998b45b2b65b5"
    sha256 cellar: :any_skip_relocation, monterey:       "a534cfe8a626f0021cbb59bc36be178167b074b8305d4d56b7e38b6501735cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba352469157bac0b0645fc0a2cfc1ec738487e2fbf3f6e9c5842c8ce9d4e5a0c"
    sha256 cellar: :any_skip_relocation, catalina:       "1d83b5507f1a4f1ac6ae3a09ae41056ab6588caab3d0737ac3707384faa45770"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a3792b0b05a830c36ed6a28b97f976ce2398806da5ac62f430eadc23bfd5423a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e47e3fbad8b97527b59bf69db9d9d765e04352e6a408827bd995091f6400f65"
  end

  depends_on "rebar3" => :build
  depends_on "erlang"

  def install
    system "make", "REBAR3=#{which("rebar3")}"
    bin.install "_build/default/bin/syntaxerl"
  end

  test do
    (testpath/"app.config").write "[{app,[{arg1,1},{arg2,2}]}]."
    assert_empty shell_output("#{bin}/syntaxerl #{testpath}/app.config")

    (testpath/"invalid.config").write "]["
    assert_match "invalid.config:1: syntax error before: ']'",
      shell_output("#{bin}/syntaxerl #{testpath}/invalid.config", 1)
  end
end
