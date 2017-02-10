class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev."
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs/archive/v0.0.2.tar.gz"
  sha256 "cfd7b847be57401e1c664662781d41bc5b089b341232d94375ca4dd612b3852f"

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "pcre"
  depends_on "openssl"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "simple-obfs", shell_output("#{bin}/obfs-local -h 2>&1")
  end
end
