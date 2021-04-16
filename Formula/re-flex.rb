class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.2.tar.gz"
  sha256 "80a84c5d58e95f4d1ecaefaee5c4211704f8f6905b2b144d4cf4bccd77fb333c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "678c0a67b75124655532e2a07ea52d93cd830c89cda3445bd044ef90580861cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "99f12d3f26babb959243c1f6e1bffc4b82dfaaeb1b2f3f65cd398e851d7b83aa"
    sha256 cellar: :any_skip_relocation, catalina:      "30157e8b9ad6496ab5e3e61c0bf706ddc264344c525b3d65dc11d2ce6ee861e3"
    sha256 cellar: :any_skip_relocation, mojave:        "eccffb6c570e488434f57c877bfb2f18e679ca9bfde522144d046a67abbc97ba"
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
