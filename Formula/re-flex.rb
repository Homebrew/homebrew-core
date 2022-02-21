class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.0.tar.gz"
  sha256 "ef9311952c11af830e8076515d46d208b9f7b964908dbfca61677fc218a9934b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d91b9f946d12dd2274e676154c1033e4b4c8855419d7bf233b8436341014a10e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "addf73dd159e2c0c8d490893385f23dd572aea8abc94ef946723565a7a156a30"
    sha256 cellar: :any_skip_relocation, monterey:       "852b752cb05e14cd32050e48751c674a655bde897b3238cc475b667b7273654c"
    sha256 cellar: :any_skip_relocation, big_sur:        "35d6aec90cbc22229ba6efeba70ab652ff530a6bb6460af4dcbdc0dbe3e2627b"
    sha256 cellar: :any_skip_relocation, catalina:       "7bef7a829eeddcbd5afa7baccf99e7affe9958ad4e5116dfa93d03bb83558cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8be6d04b84e609c05e0c98ac19a844fe71b6971da8c16eb8c3112a2f77fdd3"
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
