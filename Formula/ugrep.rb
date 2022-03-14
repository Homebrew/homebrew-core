class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.7.5.tar.gz"
  sha256 "2b237330ef92017d69ed6611b9dfb91b447d4679b9fb3704514bfd5b89a1a44d"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "6c1fb75c2fcf54e5963ba5201300eb209b1d4a370b363ac7808032debe70f23e"
    sha256 arm64_big_sur:  "7d05e75ca0b9158dbfa297fc1098dd4b7dd42af5b212921b6dfc2dc10b9edfa8"
    sha256 monterey:       "73160369cba389ed4b0fb47938b24c7bf4163cd722663c2ebc706a5c58621022"
    sha256 big_sur:        "1a204d2054a1c1cacc526416ac3df074ac2bb392d14bfa820eceff3707df7212"
    sha256 catalina:       "80a95e118d1410411e14a5b5704f6f392aa8b22090389ab0d0e3ebcd31b6c112"
    sha256 x86_64_linux:   "90b1d616d28f8ee81c4a09e65c295cfc796d453326c99835def762377809bcf7"
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
