class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.11.tar.gz"
  sha256 "4a1c9cb0d2937d0dad5572c91af30e91829359289058dbd34315017638a3719e"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "2eb2df68d4134b1ab9e7bdc0662844d854da621da256e53213402f419547883c"
    sha256 arm64_big_sur:  "151167f433748abda7992e759dd07aefda5c2c9ab0e9921daaeb3a508bcf2267"
    sha256 monterey:       "2b89a817d6a760436998ed2d578d4bf8090fbde88de8665af98a3c1025d806b5"
    sha256 big_sur:        "96b6ca0c6d8d6e9d2811fa6a2229a40827f3ebf92c49b826fb671dfe8a6dedf0"
    sha256 catalina:       "e0f8a1abca264599e956af69bca6b377f48658935b59019ccd51c42517744542"
    sha256 x86_64_linux:   "ec4512276c6b9556c34baa373226ddbe4719588a6129d164101c4f1244503dcb"
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
