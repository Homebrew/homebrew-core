class Syntaxerl < Formula
  desc "Syntax checker for Erlang code and config files"
  homepage "https://github.com/ten0s/syntaxerl"
  url "https://github.com/ten0s/syntaxerl/archive/0.13.0.tar.gz"
  sha256 "1788525472fea5b0139175abbfaeddcf7f94a875d42d5d3f0d4332f3803f1b11"

  bottle do
    cellar :any_skip_relocation
    sha256 "83d2862830f4a5d72b22ef20b11e211a661a00bbc27b9369aed56c2bcc868d93" => :sierra
    sha256 "7327d1cde23cfaecec5ea018423e3eea0801ada045460a910e26e6cdb871c5e7" => :el_capitan
    sha256 "41a04901b1cef9d2e9f69a929a92f07f3f76039247c1645fa6eb44c78c3ea276" => :yosemite
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
