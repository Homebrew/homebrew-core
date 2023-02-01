class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.9.7.tar.gz"
  sha256 "7f44e2198e2dc3ad1ed88759ece848364c4ba632aca60aefe9c53d5b0c584628"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_ventura:  "5a6943785d20705a7682b4fc7a0fa790e42390af58ae718b7167574dc5d15f57"
    sha256                               arm64_monterey: "23a245f17b740fe12ec7c3c9cdd23190b20821ab50acb9b56d5ed042463dd66d"
    sha256                               arm64_big_sur:  "3cb38fcd011a0aa61c9a4ca66c17ffe117d13b405670c0767b594b51ef7ad929"
    sha256                               ventura:        "8eac7666d9a6806683d4f53cd77b6fe7e3296b73ffc5041f57cc1c13e6a841f3"
    sha256                               monterey:       "132e7c6ffb9891c30d4a8f20a60b72e8d0582af1aa2369b15d01482c16d75a51"
    sha256                               big_sur:        "89d7b923b2552a13741fcc12a90c1583a8af67470602cc647667af8b5bc05957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "124fa40579007aede44d067538122e28b7a3171a8df3361d65d1057981e111ad"
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
