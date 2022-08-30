class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.11.tar.gz"
  sha256 "45b1b7e6bc47f567a16ffec710dcbfd4e95f0f7a34c14472809ca2fcda0ce143"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e84e3dcefb69879c24f7a012ed08e6b3ea6917fa80209fbe286f38e195f6ee8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ca2fd5b2e81696232f71e0a5dffc1af6ab19d556968b5b83aa7e80fc415267"
    sha256 cellar: :any_skip_relocation, monterey:       "1ee5cddf13f348a593b23543f99d11aa0d5b888cde01cc607961f0dfb645a591"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22f28c7ac443c24dc8d1fd3ae5d8f67b87a6eb203271ed3a4330b44fd71a047"
    sha256 cellar: :any_skip_relocation, catalina:       "3f3448a9495b6e5997ab6c47d23972707efc184f13d0564c97c20531605137f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "397413ad3694fc28d8436d4ba1ce68507dcecda89efe571c902dabca8f4be68e"
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
