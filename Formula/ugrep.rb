class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.8.3.tar.gz"
  sha256 "deb7e143ee07019fdaa98a4529596d965185542a195855c1bfb6779fb8dd5e55"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "3342c3772bf1109f89b77ecc8ae59a4213c3051b78dfae9f14770ac27e1beed2"
    sha256 arm64_big_sur:  "ed1e434d6372a612dc9d76de05dbc28c134169a5797bf39a7bebdb1cfbf35734"
    sha256 monterey:       "029f4f5dc1ac7091d4df0a169b7c157dd186ed412884b0ddf99350729ed16215"
    sha256 big_sur:        "4f7557e48bf959394753e4912bcca4eae84c330521597f8a9036797e462e2cb9"
    sha256 catalina:       "1f3532e352f3b722a76e0cf0d22c1007391b8c83720999d6c9ef65cac2cbc2e2"
    sha256 x86_64_linux:   "05f09a8cde9e5b1677a9f141c98bcf9ebc1ebf97a4c40abd028d406ee057a2b4"
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
