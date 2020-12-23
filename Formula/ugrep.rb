class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.1.tar.gz"
  sha256 "9afe1b9edc83478404fbcb47b1489c13ceb1101ae372d34b623c3521e5df0a44"
  license "BSD-3-Clause"

  bottle do
    sha256 "8a3eb003bed56dff223c7ebdcc4ef47d5969fadb79e88152cd4183e78ec9d89b" => :big_sur
    sha256 "38dc896b47e66d5f6bedc4a12488333a1e3bf94a2e6daf401a0b232a16b1b5bf" => :catalina
    sha256 "e41cbbf7b232c6833f208696d6e40d5d0625beb54795a8b9b3250a99f4366113" => :mojave
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
    assert_match /Hello World!/, shell_output("#{bin}/ug 'Hello' '#{testpath}'").strip
    assert_match /Hello World!/, shell_output("#{bin}/ugrep 'World' '#{testpath}'").strip
  end
end
