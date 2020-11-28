class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.1.tar.gz"
  sha256 "7ceab8075677e618b39451ff5487a7f463f8e1bfa7668010ae992d84eefd6dca"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "26bc4f346a6853aee25b8e4fa5519bc21422f973cac81ee56833e28fd751470d" => :big_sur
    sha256 "79252bcb97dc8958b8ca11d1aed9bcaac9e11e5960be62635c1b153bdc3181db" => :catalina
    sha256 "f513dfb9d4b581bf73f38bcb22d29517a891aee8841e014739f065899c492028" => :mojave
    sha256 "d14347780b5ba78e2a1f85f24b45640a37864bf469d9468e1e2ca7c2851caf21" => :high_sierra
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
