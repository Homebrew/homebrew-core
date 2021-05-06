class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.2.1.tar.gz"
  sha256 "a377b399227296caeca3e1b8945fcfc12001e78ad735f9d3d63d8015082608ee"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "fd8a7606d36abd6fe52145a19648c332cbfd0c48e32550d0658943d22d5029cb"
    sha256 big_sur:       "fdaf49e46a1816c673b0ba6daa6710685c62e5c5c0f004fb710e8833cd1dc31b"
    sha256 catalina:      "27409a2888ea278beda4b563cd5d43a1638eeb8be4581b346ff004428f5c1b53"
    sha256 mojave:        "d927616913b577f69f5b49d2ac5db5279a56bdeb0cb29344a49a4ad80347caed"
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
