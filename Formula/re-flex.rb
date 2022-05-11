class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.7.tar.gz"
  sha256 "e1184d98ad7ae7d8b36581058218f8c42592393506f49dcc2de0c6e09946154a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da621d951d442b682f6832593d139ae16ff7ad6a084b8e1859a0bd42c98a5361"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dafaa4763272d11b8cd20f36b2590e900ac764e220357123485f6569823a255"
    sha256 cellar: :any_skip_relocation, monterey:       "3e2d0de6dcc85206edd166175f0ac58e305b5d0e59e4e1eed94838485e0afa92"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc9165ea553bad82e557fe2bc61dd9cf87bda4b301f89ba98aea23291e9c09e9"
    sha256 cellar: :any_skip_relocation, catalina:       "dbdf80c6f2bf5a6c34d0279a69145ce29ca40bdfdcca0a60f54b0dfc8f75c20c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b5bd8f1b6f86768a4fdd29ebd07bd03150fce85cc5dc22cf482a9ea044aae1"
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
