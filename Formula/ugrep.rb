class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.5.0.tar.gz"
  sha256 "9f8469e111ee665f6f03e3a8c0e4b06e632ce3fcb90e955b8979696973cfa0db"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_monterey: "91b33c538298430916bc8409089a21d329b6c01f153e1ac15cb19f85f49b072d"
    sha256 arm64_big_sur:  "2272083558f72d0ea32cbaeffd2a83d60467aa2d59633c78c34ab3ae48a8e273"
    sha256 monterey:       "5d56b416f588ead7cbb89457d3a3486efb025b02bf9f844ba5d7e3bdebf91090"
    sha256 big_sur:        "21caa89614241e6d2312831e7644f2282cd8dbfb6459c6d9a9be289c70283320"
    sha256 catalina:       "7b95ae09dff571d67228f69d9cd9798c9e4bf1bfc3254e4dada49795487f59bb"
    sha256 x86_64_linux:   "902006adeb123eab271e44d9193569b74cbb36cbebfa51caa818aaba956cbf73"
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
