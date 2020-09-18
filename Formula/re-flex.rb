class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v2.1.4.tar.gz"
  sha256 "a9ee928b59cfe652fdb0cdccfdceb328fe41a3f102102e63451872999541c916"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "744d1ecedfb01029b74764a723f8488f0a656a3760006759898a2f9dee87a55f" => :catalina
    sha256 "b19f91870030ea8115d3ab27281385911a61755d291910d6daaf12ae555e017a" => :mojave
    sha256 "d9fa2b30958e4a595d35b908531250e160de770d6d1a52c4cfcf5d951835b0af" => :high_sierra
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
