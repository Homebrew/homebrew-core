class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.1.tar.gz"
  sha256 "65d8ff9784630d25b4e4fadef6bd1f60ddcff206fbb38f756b42f0c63c6b2c23"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "d45c0a369d041eafbe954ae2a3847d8a37cd0e2382cb2b9f5d9ce29184b58cbc"
    sha256 big_sur:       "68b812e4597d4ded15edf1c8476cf539683eda4fc15b0fda4c539d5176e99204"
    sha256 catalina:      "3f3de6dbc24da44c454af4157785c17f4aed1a92019571a5024a6c10717857f4"
    sha256 mojave:        "0779e31c228bc0737f8003feff1557497d676aec73e0132d1a5c20be5ce21e80"
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
