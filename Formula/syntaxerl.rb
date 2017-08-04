class Syntaxerl < Formula
  desc "Syntax checker for Erlang code and config files"
  homepage "https://github.com/ten0s/syntaxerl"
  url "https://github.com/ten0s/syntaxerl/archive/0.14.0.tar.gz"
  sha256 "a7c46789aadf467191f43b82ac6a428faf4d38af2965fdcd946789a7f40439fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "83d2862830f4a5d72b22ef20b11e211a661a00bbc27b9369aed56c2bcc868d93" => :sierra
    sha256 "7327d1cde23cfaecec5ea018423e3eea0801ada045460a910e26e6cdb871c5e7" => :el_capitan
    sha256 "41a04901b1cef9d2e9f69a929a92f07f3f76039247c1645fa6eb44c78c3ea276" => :yosemite
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install "_build/default/bin/syntaxerl"
  end

  test do
    (testpath/"app.config").write "[{app,[{arg1,1},{arg2,2}]}]."
    assert_equal "", shell_output("#{bin}/syntaxerl #{testpath}/app.config")

    (testpath/"invalid.config").write "]["
    assert_match "invalid.config:1: syntax error before: ']'", shell_output("#{bin}/syntaxerl #{testpath}/invalid.config", 1)
  end
end
