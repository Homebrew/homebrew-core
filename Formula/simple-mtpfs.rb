class SimpleMtpfs < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://github.com/phatina/simple-mtpfs/archive/v0.4.0.tar.gz"
  sha256 "1d011df3fa09ad0a5c09d48d84c03e6cddf86390af9eb4e0c178193f32f0e2fc"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "d902aae104d1f2ae07bdb28ecabbef8d9d97d9326a3e29050c83a4dd69597ed4" => :catalina
    sha256 "4f9c18fb88084e24773591124bdcfdc0ceb3741f2cdaffa2d67e7b22cfe5672e" => :mojave
    sha256 "0a22b0fd5ea759ce48068efabf40ac09b4a76d5dcf942db8b672edfd3e1b90a8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build # required for AX_CXX_COMPILE_STDCXX_17
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmtp"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
      "CPPFLAGS=-I/usr/local/include/osxfuse -I/usr/local/include/osxfuse/fuse",
      "LDFLAGS=-L/usr/local/include/osxfuse"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"simple-mtpfs", "-h"
  end
end
