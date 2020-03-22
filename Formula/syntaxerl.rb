class Syntaxerl < Formula
  desc "Syntax checker for Erlang code and config files"
  homepage "https://github.com/ten0s/syntaxerl"
  url "https://github.com/ten0s/syntaxerl/archive/0.14.0.tar.gz"
  sha256 "a7c46789aadf467191f43b82ac6a428faf4d38af2965fdcd946789a7f40439fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e37cdaf043add132428e29854d4d1cd0aa5dc039387671ba000b9ae26267d6a" => :catalina
    sha256 "569cf5e87181031c9b13dd6cb2f4fe17967d4392c87a2db30d498883a05106c6" => :mojave
    sha256 "2b4c6e6d7e7413fe81e5107e80841f5a8c4bbddec9e12f3f53c92bedd5fced3b" => :high_sierra
    sha256 "0e0ac8402dd61720eeca50047b173f7500dc38bd7cceb37915c4425b7492044e" => :sierra
    sha256 "648f30c4fb2db062f4c9f27d3c73cf679181e7183a5b7b83b5670624d88b27d5" => :el_capitan
    sha256 "80ea1737253a2115722350d6a6456ba48ae853674bb91f7a8b685e7b8311eb74" => :yosemite
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
