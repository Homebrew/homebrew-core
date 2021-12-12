class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.12.tar.gz"
  sha256 "24f7de6d1dc2263a75b455c461c2d04b3a719d4165b6383c99d270b99758878e"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "0585a3859eda98f1748bbdac1391b7959978e7a0090a104474934e7cad52977b"
    sha256 arm64_big_sur:  "b114a29c7391e632aa626a8c7d7d86a7c7632dc6af41145eef5a7f58ac11ceea"
    sha256 monterey:       "448920b3f8e451cded1dd9bfe4362f10c84eb3d2620aa57a6660f4b2411b5611"
    sha256 big_sur:        "f083a71acc243a5e6639f28f13a0c5c0bf3a94a3c92e355d48193fa09a368fe8"
    sha256 catalina:       "25f1187028bb7f5a80289826e812a6cf68fdf49adfdc0c168b6d5f202e107269"
    sha256 x86_64_linux:   "827668a0123dc965f5519c2dd72cf1fdca05c677881b2e73b1af3436fc348b7a"
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
