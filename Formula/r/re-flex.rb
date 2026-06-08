class ReFlex < Formula
  desc "Regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/refs/tags/v6.3.0.tar.gz"
  sha256 "c9e448b621734238c22352f54562bb88c1c6c18450f89d8fe6a2eb2bcce68a2b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "996e877eb9426eb383e76f7a5930dee4f607277379e6701ac8e00b232e27dcef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a62db6b60b473130a24d91c68c071a26d97ac8b6b6a16417d1fe2de1b10759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7e8d96b240548c3b5ce390234cd26fbdc0eb13da6fb7e9d129db5a44cf1a01"
    sha256 cellar: :any_skip_relocation, sonoma:        "b05e796aa7090e2542c6f8a8e65df43a5adeeabc09b9aace13093b874b5f14ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1d6f30ec3f0d249ca91e07f7c672710e5de98dc9d56b14cce88c43e57a89a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f2061d3ee5e8418d0bc18be7508ff3519124a77b87afd4e901fa8a205687901"
  end

  depends_on "pcre2"

  conflicts_with "reflex", because: "both install `reflex` binaries"

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
    system bin/"reflex", "--flex", "echo.l"
    assert_path_exists testpath/"lex.yy.cpp"
  end
end
