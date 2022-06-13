class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.8.2.tar.gz"
  sha256 "a5f9bf2ab204b05f34f752321ad96ab950a86a955737d313886614742e9c5fbe"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "143b242b604bc2ab381a331470647f9e50bfecf34b1da41189f75cce84662c6a"
    sha256 arm64_big_sur:  "c29503bb4b87fe88f53b8e0f1a87770eadd45749379e62f43236e824c468f082"
    sha256 monterey:       "017b1350ad8749066b2e030e3b23533ba4fef6eb168098a5c35d014680d4366f"
    sha256 big_sur:        "a9ae0f11e7d2539fe7a79d2c17e2158758fdb51ee7f843ea3e6a7169d761e90b"
    sha256 catalina:       "b795722234638df3096b972f96e4e8eb213cb8ad80389ebafd04bdda1a2af9e3"
    sha256 x86_64_linux:   "6a7d2bab5eb85ae3deb8c9ea0afed4f5995e39148dede62e5c20ffc0bb0689b6"
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
