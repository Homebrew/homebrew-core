class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v2.1.2.tar.gz"
  sha256 "d5affd1b2368b5a14377089416b7357a16e8f4ff6738ed30c06018a3715fc270"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "e387dbf803291e3e6697bfc6fe9b3c8c69ad22d4210663f0a66c69afbece5f9a" => :catalina
    sha256 "03c06176e433a06473c664278131b1ee0fc2556c85bc148bdceac58b4ef5871d" => :mojave
    sha256 "70eb4ac6db4ea719aa42c8ecb081bef540d63025bdd5e28186f2eda239ced202" => :high_sierra
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
