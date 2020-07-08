class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v2.1.1.tar.gz"
  sha256 "75994065b7a8aeec0c41f86afe7d33b571a73f124a001ad9a4bfe500641a9670"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "55efb461c3d5c7a279a754e22287b390050a84fd8cc80011631c4eae4d1a38f8" => :catalina
    sha256 "af3b9a64a7045d923351705b32b34d2c8028c1381fab9387d162e2dece23c15c" => :mojave
    sha256 "175db6f8c316981695107b02d12675735ba28c3efcfa7ecc7ae2857f9e46756b" => :high_sierra
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
