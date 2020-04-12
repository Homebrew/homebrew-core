class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v1.6.6.tar.gz"
  sha256 "be98ae3b270ebec4261f5bc78b5bbbe02ce6afee080c175c9a6bb8f01e28eaee"

  bottle do
    cellar :any_skip_relocation
    sha256 "159e3a513fc2be997b15647eced2eca0054860eea6494b3242e5769eecc7c2a4" => :catalina
    sha256 "35c239d558c4cb7ee7d8b8562f968011909c4993c1610b466e5d5b407680b985" => :mojave
    sha256 "0f3c5359e904914ab5b31daa51c23d8009eb850b2fd7ac41f933e235141e5bde" => :high_sierra
  end

  depends_on "boost"
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
