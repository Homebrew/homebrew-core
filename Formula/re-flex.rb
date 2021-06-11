class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v3.0.7.tar.gz"
  sha256 "2121a055f294ba81dfee149e1a07d6d00d81b467bc44d3feacc9ea4d7e0362d5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0320022e47a1cd77e47b97ea57d188db729e96a6475b15a8a4c4ab47b666cdfa"
    sha256 cellar: :any_skip_relocation, big_sur:       "25db2d95d2e08b8b5f216d0af67e769cd1c0e8dc7530abad14d4303f08f981b6"
    sha256 cellar: :any_skip_relocation, catalina:      "6577b7d550f87fb18f7379e8b93823b4b5262a9f173062d0852afa18ac7d64e9"
    sha256 cellar: :any_skip_relocation, mojave:        "b071537d78265ec8de66fb32b7fa4a18dde206fce2da8a4b076c3613dd4cddd8"
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
