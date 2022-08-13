class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.9.tar.gz"
  sha256 "b24eee8d1c8a1c18be260aa170cb8076a0a5bb1fc4cb3f5e21b05ae80ba7f377"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53da9f4fd72c5c528c34c90f8ea26e3d5502ed308f9be528ea366406fbed17cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aad4538bd0ac9982ca922627c3aecb85c7d7e117f39dda673327f056e3f9fe02"
    sha256 cellar: :any_skip_relocation, monterey:       "54f6a9b5fb02ffbdff7f38790be724ad848a7b0c40a377ce7d70a06aa779f234"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4c0a98711c108c82a7df82b0f2c4167421ab0ceac1c602c0d90dc11fd6f844e"
    sha256 cellar: :any_skip_relocation, catalina:       "0c6dc320da2bedf91069bca90d6ae9e46752304bac71de59f7cad1c99331c42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b1cd6957a3fb8fcda904211572613be22a2dd1613fa08097432e1675caac98f"
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
