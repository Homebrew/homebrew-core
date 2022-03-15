class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.2.tar.gz"
  sha256 "e6f04f81fc0f23dde0585e6382874c1c36ed05759db02115c69e3eaa5f90fbb6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d1352fae05c13f5f40cc69d1578985a5a4bf95b976e3e5fff1b6856501ba65b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c690c7820fa0b75c9dbb0ac6a84b22806a25f14896a02eae9ff3d9e22cae3274"
    sha256 cellar: :any_skip_relocation, monterey:       "33bb3ba3d61503f8e341f8fc6666f438e3f48e9d616096f9d42adb3bf5a558fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4f709a4e3b65d0881aafd05e79872d9f354d4a10802a5b890eac64b718a6112"
    sha256 cellar: :any_skip_relocation, catalina:       "12d7c355b2c38b0d01bb283e19c75f8178c486a43b1ff8be341f87fabae5a2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cea7dc7192454e2c3cfe693221959d8ec3dc2e9225491dda17fcab9c59d3d87"
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
