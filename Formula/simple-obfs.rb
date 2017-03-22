class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev."
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs/archive/v0.0.3.tar.gz"
  sha256 "350c22e138202868d5726cb55e3d71e9962aad3306988a9f746b80d0e8998a75"

  bottle do
    cellar :any_skip_relocation
    sha256 "48259596cebc653218edff860e18a1f0daf53d6c8180969e62adb466d2c3e97d" => :sierra
    sha256 "ce861a5056909c62375f163be15a4fd061473d555c60e6295d0656e513f2df7a" => :el_capitan
    sha256 "62eb73c58140f4cbcc36715dd84fd6e95385f96eddb4f48ffc11a655b91c842d" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "udns"
  depends_on "libev"
  depends_on "libsodium"
  depends_on "pcre"
  depends_on "openssl"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "git", "clone", "https://github.com/shadowsocks/libcork.git", "libcork/"
    Dir.chdir("libcork")
    system "git", "checkout", "3bcb8324431d3bd4be5e4ff2a4323b455c8d5409"
    Dir.chdir("..")
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "simple-obfs", shell_output("#{bin}/obfs-local -h 2>&1")
  end
end
