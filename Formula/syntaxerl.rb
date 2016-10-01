class Syntaxerl < Formula
  desc "Syntax checker for Erlang code and config files"
  homepage "https://github.com/ten0s/syntaxerl"
  url "https://github.com/ten0s/syntaxerl/archive/0.12.0.tar.gz"
  sha256 "41245dc4ec6fe5e38f9669480ffe65789781e7ae93094e7a6c9eff21f9b7b234"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5b022d728babd0fd5f492b45f63e99b4ff9086821ceb250a085a051f33e5b68" => :sierra
    sha256 "e41ec5d0fe9d78f9574c8ddeb08943e4e4d09cc826e7012d089ca7ed0d719523" => :el_capitan
    sha256 "9402057ae3c091f56a08c2746ac0d56da0bb337250c9765ccc01a0e1f2331656" => :yosemite
    sha256 "ccf1aecf79fbf0da7f8857a88ce536068095148d47a9791503b256cde0eed2d3" => :mavericks
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install "syntaxerl"
  end

  test do
    (testpath/"app.config").write "[{app,[{arg1,1},{arg2,2}]}]."
    assert_equal "", shell_output("#{bin}/syntaxerl #{testpath}/app.config")

    (testpath/"invalid.config").write "]["
    assert_match "invalid.config:1: syntax error before: ']'", shell_output("#{bin}/syntaxerl #{testpath}/invalid.config", 1)
  end
end
