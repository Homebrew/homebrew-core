class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "964881baba9d6a7740a6567756b472f9ad63bf8739f429cd28a9cd159bccf21c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e68a48b64e43aaad6e6aee54f50a4fb0b8190e66fe0523329a1062f97da828c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b9c4116e1ab2d5df06d97478dab33784e76f20c59e91790d17843666a1a7ed2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "219fca9edaffe5dd20fd3b25eb90f2abfd2c76f413059ef2efa5861a0724bb44"
    sha256 cellar: :any_skip_relocation, sonoma:         "34479728358131cc2de9cbddbf545435f2aa121409d7bf4395f9896b965d85ca"
    sha256 cellar: :any_skip_relocation, ventura:        "8441ab7781690c984da77686116568740e710cf61130ab1c2c5914e5c584ad28"
    sha256 cellar: :any_skip_relocation, monterey:       "e06d60b8fe9168455bd77b4b22c032dedb0a514301f9b3ed8b15133066cfe938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a2b06c556335342ee5d18f95d0836056f33f16e205d3db3851f056c09a2d2a9"
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~EOS
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
