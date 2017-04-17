class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev."
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs.git",
      :tag => "v0.0.3",
      :revision => "1f5dcace9ee50da6144824b9db9e89be889a9033"

  bottle do
    cellar :any
    sha256 "bd8a043875d1e1f36105af0395a938c16fc92dfc494c1ec13f20847737ddae39" => :sierra
    sha256 "dd9f3e70aa648d9e7dd625dc56b5f07e593c7d47d48fa73095db7651d8e5a85a" => :el_capitan
    sha256 "d4c927a5c809c907d7b8641a0e13d3ec23745a143fc9da496d96b8a2352c7782" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build
  depends_on "libev"
  depends_on "libsodium"
  depends_on "udns"

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
