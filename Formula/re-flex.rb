class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.0.tar.gz"
  sha256 "ef9311952c11af830e8076515d46d208b9f7b964908dbfca61677fc218a9934b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e17b6135a6ed038f3f429aaacd356add330192f7e67716a5e327ffbfde5d3a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25d85a4cf6cc3153cbbd98e8922d453254fc96b37c26308fa2ced46fd8760eb8"
    sha256 cellar: :any_skip_relocation, monterey:       "047aa471be705c47df992d5be18ba9a368f8925e7063084095a9fc658639f7be"
    sha256 cellar: :any_skip_relocation, big_sur:        "1438bcb1b9c9431663d1181e0760ab748fb71837544b6e722e82e8e3118f01cd"
    sha256 cellar: :any_skip_relocation, catalina:       "74ce00cadbcd5109e0331d806f7989b76a6bd4f1a19f441467475c8231050b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0724625bded9cf2c52d1994e9788c2a647f48a6ec05f28165dacd6a8bb90bf"
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
