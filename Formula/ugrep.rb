class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.6.tar.gz"
  sha256 "5e494bccabebfa91b4ac34b0c44ac6e36fe8604e78ef4b22c099f68e82e32e35"
  license "BSD-3-Clause"

  bottle do
    sha256 big_sur: "e94f3cafb0e591123c3a01b12209591f6a870ec1049d1dc1312896fb378b9a0c"
    sha256 arm64_big_sur: "941dcad637033a0e4d38c93bc79b79f46411b9bd4d39416f9d92ff4328a00032"
    sha256 catalina: "487868bcf757d35155a481c4da18f9baf82027c8d5aaf158e716c29df28dd38a"
    sha256 mojave: "76ce22c22395088117be27d1926e40157fee3820c6d15a44ac9c731d29a472aa"
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
