class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.2.tar.gz"
  sha256 "e6f04f81fc0f23dde0585e6382874c1c36ed05759db02115c69e3eaa5f90fbb6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59f185711c675ba6ed50a34db38abfe931e0ddaa8f1bc2810c5a829e614865be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08f97cc6cff99245810e22cc31df9257114b8146b35a6c2fbdd7b1cdf3929cab"
    sha256 cellar: :any_skip_relocation, monterey:       "36a4a489ad56bdd6f0d6ca9ed88ae19eda16f3365a9ccebde05f83996eb5828e"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c654ed98ca1908b09c12ece0437238a4f1754932221d2350d3412d1e62f31d"
    sha256 cellar: :any_skip_relocation, catalina:       "f7fa7e31fc58eec35ba8e698a918028bb570907e027a92c06a915de476051bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24e2ac0b56a179c28fbc030b18f7aada1a6ac4d952560c5cd72d7fedfe6ee6f2"
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
