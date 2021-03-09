class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.9.tar.gz"
  sha256 "c2a94fbacf8cf0f7d35e73fabbe4a6afc20feff8c340c9ced7a22343a8d7a569"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "c34957a11fc70a17ddce7c533db394a11313888c06b7b779324ee09f5cf38b01"
    sha256 big_sur:       "501a724110b4e1deb8b32db80097644bb9742114f1a45e3fb087290c8491c4e2"
    sha256 catalina:      "a17da71ffc9f7e139cf72ed5aa6bc309b1303373dae6814693d14ca210aa88f6"
    sha256 mojave:        "8d93c9c30eea6b835c26ec39798a4a5f95a158a8d02a0dec87ad5e2459766866"
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
