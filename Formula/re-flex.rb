class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v2.1.4.tar.gz"
  sha256 "a9ee928b59cfe652fdb0cdccfdceb328fe41a3f102102e63451872999541c916"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e8011102f27d9811bf1aacc7766ea22380759c5cf84b166e008bc8f410dd1ef" => :catalina
    sha256 "93bb912cf8af0a002b45df76bbf71e35059366a7faf610727cd5bc8d72b182b3" => :mojave
    sha256 "9c754ca9c993c65d8a158b28a2db4b8e45fe2e4b4fd382b34c2b973dc07c7a72" => :high_sierra
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
