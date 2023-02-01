class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.9.7.tar.gz"
  sha256 "7f44e2198e2dc3ad1ed88759ece848364c4ba632aca60aefe9c53d5b0c584628"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "ece4d50484603dbe714661e96d1884bb60dc864b2126080b5b929056d84dffea"
    sha256                               arm64_monterey: "7926934eae57555e087b1f5dd8f6422bfa0da13a21fce370a7c53f6737945182"
    sha256                               arm64_big_sur:  "a8834008fc771dcc68f3dff5c3dc14761d2a6e4f8ef3b886a900c80c2d0c411f"
    sha256                               ventura:        "928831b15d7cdb13237002e8f794337ff5d54dac6ddf94bc9a439a3cafc23713"
    sha256                               monterey:       "8b6ef610a07f320b19624c342da8eff4ff3300a245cd933309886fc4320bb449"
    sha256                               big_sur:        "d1d7f9a8d493bd70bfc7d39db6e60d9e604fba2e71efc6dbc892dccf8ab95a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ca9a4201c44c8b41a98e22ecb2f4dcd0b0288deceb325943b2f047d7774b9ee"
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
