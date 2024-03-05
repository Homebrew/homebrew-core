class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "964881baba9d6a7740a6567756b472f9ad63bf8739f429cd28a9cd159bccf21c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d411381d5d7f61630f7f4bb32b28402b61dff4d89b409d7fa77605f1b6d6877c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e3711963617a033e5771665321ab89748e39c761a91947377d0709083a81b44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d15ee5c0bd1da79874a24b1657e3942144a48bf7fdbaaad8a4fd19ef39a56f50"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f6f3b58f0c1b741cec12ace550a2ff14c46c1bb1d674f81a590f4ce4b2ae6ad"
    sha256 cellar: :any_skip_relocation, ventura:        "a207a8e58eded45b4af0b839022ccfac72751af39983b289cd5948223013b729"
    sha256 cellar: :any_skip_relocation, monterey:       "16d45338d46a018f177cd5a6ef9542b572f513de8d2f0ffd4cbac0a4ef5ee3ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0064e25d0f262614a31ca28a0a5b4cafb47b417561af4a09906067466c00d58d"
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
