class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.3.2.tar.gz"
  sha256 "84a467d414d97cc4c00e85000caf1b9eccd3a815078573ed199b708c036d4dcc"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "bb9fe087ecb8f5cf5638220cc337904e784c7e0246387b496299381c4dfe89a3"
    sha256 big_sur:       "3b5bdc4bf53f6a9ab76889216abcfa2f60bf6f538453a43fc3ae923250b908e3"
    sha256 catalina:      "59d376a23a1afa1e6869add2d5f36eb425d36befaca7ee8586502aae0dbdf93a"
    sha256 mojave:        "0f588ffaf85e7405cacde36206fefc859836fd67f40e9c1b3190713ad4b1af21"
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
