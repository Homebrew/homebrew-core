class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.3.5.tar.gz"
  sha256 "c8f73cb632631bfbc68cb05c7312695c3df6361b0d3304fd145f6fa947645515"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27db01109fa225fed5aec28b614cb1562ada21704c3615ad3db8a02d05499dae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f7367539b0bbff9255507bd776e28443c87f1d71b78f1d5d3ce0e6c9ef08a0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eca94635823fc40c1d35f24993597f642a19efa2657fed93fe1613bdc6051d3"
    sha256 cellar: :any_skip_relocation, ventura:        "9baea0a9e9b653c4da4162d7636d659a8b9aabef8ab673f7030fcb30bdfc90bf"
    sha256 cellar: :any_skip_relocation, monterey:       "ed105222d1db059c790f37fff0f02a8ba0d3b5c7157c9e06c4c2b4a1c6bdd09c"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ea987d57056362d5d2ec61c770a791a41d47b129ee34be5152d220a0bc752a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a07aa72dd270648f8a866b430f447b17fc479f786770e0acb3fa9214f337eb8"
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
