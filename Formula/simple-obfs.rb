class SimpleObfs < Formula
  desc "Simple obfusacting plugin of shadowsocks-libev"
  homepage "https://github.com/shadowsocks/simple-obfs"
  url "https://github.com/shadowsocks/simple-obfs.git",
      :tag => "v0.0.5",
      :revision => "a9c43588e4cb038e6ac02f050e4cab81f8228dff"

  bottle do
    cellar :any
    sha256 "07ba824abdfcb695b68b7c6d53a366d38db3bb9f331f1eda8a9c734bb0009ced" => :high_sierra
    sha256 "1dd5c23375157be7614c83107630ad9ea0c17de500783f4bdc76194dbf3a2954" => :sierra
    sha256 "44e0ff7c8fa5bbc12d2f92e9db87d7e7d2ee74b984d74e9d55f8963855c3df23" => :el_capitan
  end

  depends_on "asciidoc" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build
  depends_on "c-ares"
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
