class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev"
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs.git",
      :tag => "v0.0.5",
      :revision => "a9c43588e4cb038e6ac02f050e4cab81f8228dff"
  revision 1

  bottle do
    cellar :any
    sha256 "58e68065d6330d4caa4bb5ed41e1c710eff2de931394a58246e495a0594cb59a" => :high_sierra
    sha256 "91b12c599757a609bcdac412ba4f1e86a8a1e7aaac78adb9dbc92a11d5ce14d9" => :sierra
    sha256 "5e8700c86709dcf6d045a7d0b842097a3ca06a0cc4a28d9750aa47f3161e528e" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build
  depends_on "libev"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-applecc"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "simple-obfs", shell_output("#{bin}/obfs-local -h 2>&1")
  end
end
