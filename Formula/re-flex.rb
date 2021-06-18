class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.7.tar.gz"
  sha256 "2121a055f294ba81dfee149e1a07d6d00d81b467bc44d3feacc9ea4d7e0362d5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1041a854a0de92f8ba5230cbcbdd841e3ac76fac93888fba232e9027833478c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "e6edac151062c1b4079f1d54c2781ca23d18e702ee1d45e3e564d3004838f85c"
    sha256 cellar: :any_skip_relocation, catalina:      "31cc9b8ffb19cbbc0d1218a3cd04e89666c9bc5d061faa91fe0f2fb0950d0c76"
    sha256 cellar: :any_skip_relocation, mojave:        "32bb81f4af0fe2c310acc5643288d23bc2b9ee7386e59b9943bdb355abeea99d"
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
