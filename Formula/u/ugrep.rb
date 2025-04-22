class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://ugrep.com/"
  url "https://github.com/Genivia/ugrep/archive/refs/tags/v7.3.0.tar.gz"
  sha256 "79c10e24422372718eb8e6869451f0ecaf21586a534d259809f9d1ca8e891e96"
  license "BSD-3-Clause"

  bottle do
    sha256                               arm64_sequoia: "78db670d7fc9dcfaa0caa7d2e0249b47922f0b8d1f55ad6031c3c13028cd2beb"
    sha256                               arm64_sonoma:  "e1a78d16ae4f92f10ead368b5acf1753a272eb6e7754641557ddfd23442f32fe"
    sha256                               arm64_ventura: "7d03d258f1aba9b8697c54e5575f74d30a9f12c0efe5e6039bedf4a1c5219abb"
    sha256                               sonoma:        "76c8118b88df177ef450920568152187aedd390e9a6181a05a82c1dc828f198a"
    sha256                               ventura:       "b4087a3efc66a43ad67c66e1a463f34477ca499488d981b47e2caa4e6db2bbb9"
    sha256                               arm64_linux:   "3b9f3809d3a93b68512a4c8f44074c644765879b13b77a70350e0e16022c9e3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cc91a7319f6e11e7c783956889940bec51c1ff05875696b624dcd2d3f31b8ab"
  end

  depends_on "brotli"
  depends_on "lz4"
  depends_on "pcre2"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
