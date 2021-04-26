class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.12.tar.gz"
  sha256 "f783b8bcc628f792ba418f073b38f089a14d709cbd0438ee27a0cc437e0543ac"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "4177b74d9020fcad9b39dac77c595690f4319f8ec6fd12c0b7c7706ad78d5a21"
    sha256 big_sur:       "05c376f9fa52d1ce0d0ad191df95935ca1c9af4db06e4ecd25c5cce5f89ce38f"
    sha256 catalina:      "2fa27d09ffe318d107a00d7c9df338bf658273da475d4aa63846775b3d0525a6"
    sha256 mojave:        "c10972abac81f845f3fba016cd535430471b615886a328b8dd5127fd83dbb8ff"
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
