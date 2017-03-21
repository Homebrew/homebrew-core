class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev."
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs.git",
      :tag => "v0.0.3",
      :revision => "1f5dcace9ee50da6144824b9db9e89be889a9033"

  bottle do
    cellar :any_skip_relocation
    sha256 "48259596cebc653218edff860e18a1f0daf53d6c8180969e62adb466d2c3e97d" => :sierra
    sha256 "ce861a5056909c62375f163be15a4fd061473d555c60e6295d0656e513f2df7a" => :el_capitan
    sha256 "62eb73c58140f4cbcc36715dd84fd6e95385f96eddb4f48ffc11a655b91c842d" => :yosemite
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
