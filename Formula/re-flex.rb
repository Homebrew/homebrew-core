class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.2.9.tar.gz"
  sha256 "b24eee8d1c8a1c18be260aa170cb8076a0a5bb1fc4cb3f5e21b05ae80ba7f377"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd91021910072b8bc4e025b7685b293fff0b88912aaa006cc34de7b36d7e1814"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf0dd241c7dda5fd822b3d94478fc8c68a5942d86378ca05e6394929b81b4479"
    sha256 cellar: :any_skip_relocation, monterey:       "e0d240a214114ac6e53c26222047304e65eaad3290ae20caea0ef518524fd6af"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcb76a71fed821ff02a0ef74ddfb1a45166c47f98f8a8bc1424058a1751959b2"
    sha256 cellar: :any_skip_relocation, catalina:       "e8781ea5edfc63d0235f6916119db030b7d9676d6167aff0e017f01e9291ed83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a48aaef7b62e114990fa393f8749f176b9b324bbcc3afa44cea35252568a6a4a"
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
