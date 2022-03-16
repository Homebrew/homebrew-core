class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.6.tar.gz"
  sha256 "8288af9eb9f5a5638134911e9e81c8b37d02f29223d473dd96a2046c228cd5d4"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "9097adc31efa43c5e6bca065ac9a4e79c83a4b6a7df75080d8c9777bcb70df99"
    sha256 arm64_big_sur:  "b5247f7c00af6dd62e27ad925d84893b38f2b0d4aa399ad49ce5a9533e32db07"
    sha256 monterey:       "aed9d8eb59d5bd7c78426e074b2d73034fb5d34255c4465138724e76efad231a"
    sha256 big_sur:        "4e68707013358af6031fdf5b32ddd9de4efdd1fa629657eab87eb0eff9810938"
    sha256 catalina:       "87363e3c5838f8889ec93ec4d1fd3cd5c2c5c5631e8df64d3bd4db684f336513"
    sha256 x86_64_linux:   "b05e08280d242fdfae3e55ca47cb47ab9b2133971d0f9c367851ceeedcf6931f"
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
