class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.7.tar.gz"
  sha256 "e1184d98ad7ae7d8b36581058218f8c42592393506f49dcc2de0c6e09946154a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "515a7bd12151548017b50b8c03d1af04b13e5f1728824491efc9bc024da619a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "414be5e19b226d6540afefc9e7a63f692a50e1181139ee7ebe13bccd050588f2"
    sha256 cellar: :any_skip_relocation, monterey:       "bfa8d25c42c4efd907e59c5d0d9084bd0d0b827c04c70725835dbf6d50bce35c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1b1595204f3d27e2c63dbcc543c6d7bb921adcadb053c7b307ef41290d75754"
    sha256 cellar: :any_skip_relocation, catalina:       "0357a392b3718893add128c748ded72cd7b510e39e8f3a6b12669b9b78a2cae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e18dafd19c71c77f9f8eb1c8fbdb65c8da8d5c4076d3a834dd8a2aca32757f51"
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
