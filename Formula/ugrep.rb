class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.7.tar.gz"
  sha256 "6125c19e33037714645a8d5a8700659d02e46a20c8e1f62c0a766d2a9bf0f93c"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "46cd3d5886ce607d56c4e33f5b2a220f8d6470e956fb59c3b90b010c08f9c385"
    sha256 big_sur:       "72eca51a4ca52aee4a1fab75fb8925ee760336837e81df420d1f72ef3bc20920"
    sha256 catalina:      "d857cb5704b92db203607987e3030d91706572139d41a1b2ee8fb9aab2acb0c3"
    sha256 mojave:        "7f2446ffe9ce59df3a61b6783bfb6e958c211caca3d89b4e50099e276c33608e"
    sha256 x86_64_linux:  "3dcc6d83f09bbccc7c38c1f4875bd1feff86ab38268dd7142db7d0553ef327d0"
  end

  depends_on "pcre2"
  depends_on "xz"

  def install
    system "./configure", "--enable-color",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match "Hello World!", shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
