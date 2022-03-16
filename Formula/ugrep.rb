class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.6.tar.gz"
  sha256 "8288af9eb9f5a5638134911e9e81c8b37d02f29223d473dd96a2046c228cd5d4"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "4c28ad0e93010565a520d9cf21033c88f710644d2517cfbf2630a9a556c1b129"
    sha256 arm64_big_sur:  "88084d55f8eb54dfc3f7a85f1370e90a3a2a8dd9bc4ab08bbb921316e1d6f4e9"
    sha256 monterey:       "52a9998ba1a5baec79300be8e1446ad8d6187c8c2cdb7dd5c2348a213b45cd04"
    sha256 big_sur:        "b1b03372badc402ca13f551f5df821b7d404ed8ac8ac03c1e2eb53387b9a7bb8"
    sha256 catalina:       "5b1dedc082affe41b7577439a2cef3bb17fe329353ddf3203709d170b7c83451"
    sha256 x86_64_linux:   "c026e227f37f7000224e2645dcac267969bab2654082b94efcf1a5bc96984b1c"
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
