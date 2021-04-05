class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.11.tar.gz"
  sha256 "43542115612f066ae22610da1510356955b142135bb23e97ed4266be28ec3e13"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "652427869a601860828fb11162377ec1570a98bc0bb565198ced1894b4974176"
    sha256 big_sur:       "d46df813bb0a3d2b1b019cfe193334d7999395fdc0d322483fecb56af5fd396c"
    sha256 catalina:      "7049b14ff6d5919a23fce7f6d5bc488cf58c018174ccc75d1f69b46d6c017a22"
    sha256 mojave:        "023348f89e0d0fdfe630ad4dc28bb977bb56a5b09f70fdce26962586c1a746ad"
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
