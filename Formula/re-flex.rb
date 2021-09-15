class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.10.tar.gz"
  sha256 "3291f1d39c3ac468ec67d56d4ea6b25b55c987e907c84d1c92cedf19988b0406"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c54cf215649b0a413d7db580f59ad9b2069df85f0b75575e494cd5471227048d"
    sha256 cellar: :any_skip_relocation, big_sur:       "48879c2ef8a01bcff4cec2754623ca3c20de1b1f53be24ead610562e65b31273"
    sha256 cellar: :any_skip_relocation, catalina:      "96866e58df2a4f3ef71e4751b779874582f0990d0cc012054e9070d55a835f72"
    sha256 cellar: :any_skip_relocation, mojave:        "1dcf84b9f3733aed1dbdd1a51c89aa6e5a13b1d3e93d582839e348bfedc44a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580435afab4101f0d45b74f1473b108c8b3843e77688121cce7bd2475906f0c9"
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~'EOS'
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
