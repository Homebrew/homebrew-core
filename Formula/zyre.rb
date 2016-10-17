class Zyre < Formula
  desc "Local Area Clustering for Peer-to-Peer Applications"
  homepage "https://github.com/zeromq/zyre"
  url "https://github.com/zeromq/zyre/archive/v1.2.0.tar.gz"
  sha256 "5a47dd553ca699ee7c4b4b11c5ea316d11267adad1bfd3ad48c3c5d608668596"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libsodium" => :run
  depends_on "zeromq" => :run
  depends_on "czmq" => :run

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "zpinger"
  end
end
