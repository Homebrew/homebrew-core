class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v1.1.2.tar.gz"
  sha256 "89022d215be79e5b9d846711de44f7ac5176bab959f7c6ff456f00714c5783c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "be67a520e18f912a3b292371270020b3537240135b2da12573b6dc054b75be32" => :mojave
    sha256 "a3231afa635eb51dd4a08ab997547fa8bf00f41d4800fe1dd0b157b4facd3d81" => :high_sierra
    sha256 "2cba3e4a8f73fb3c612549cf664b02e909cc94792c9440189074051157d2ccee" => :sierra
  end

  depends_on "boost"

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
