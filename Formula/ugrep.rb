class Ugrep < Formula
  desc "Ultra fast grep with query UI, fuzzy search, archive search, and more"
  homepage "https://github.com/Genivia/ugrep"
  url "https://github.com/Genivia/ugrep/archive/v3.1.15.tar.gz"
  sha256 "a34457751f1b99d12a98404d04bfe96c16fdf0960df7e9141b03e41ed0a62de8"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "92f591ea57706fbd4ccdeb6a0d3e399a6461e528a010eaaec9f4bfd62737c266"
    sha256 big_sur:       "d7bd2540fec7baa4f5c83d29a91fdae866addadce84aa7261173c6f836fbef43"
    sha256 catalina:      "5e55c1bbc94155ae9a8aaccb94521822e77065d135139a7306d0d9918791fb90"
    sha256 mojave:        "c01978306ac318ba3ddcd7830b24a8066714057ac530d38e42cb4d9f7e7f72da"
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
