class SimpleMtpfs < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://github.com/phatina/simple-mtpfs/archive/v0.4.0.tar.gz"
  sha256 "1d011df3fa09ad0a5c09d48d84c03e6cddf86390af9eb4e0c178193f32f0e2fc"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "0898a8c722d19687e944b9fde21f85b4f5399ae755c92af08c2e5a8e30f881f8" => :catalina
    sha256 "a393f294fa56695eb464e64898e3607415a3de01b223576cf5d9e9571b2d5a8c" => :mojave
    sha256 "799625dbb36244feab3e209487c12d99467960ac14e80017552dbdd6a4f42ab9" => :high_sierra
    sha256 "e73ec4a78592b0fc76d86d3027615e2e8addc8b9a30da9caad433b2d1fced262" => :sierra
    sha256 "947d0e96fd262e1d493662955b3eb27e247d3fc52ed1e8dc07e58a4fb167892f" => :el_capitan
    sha256 "64c1df0ab967904c00f8b61d41bd4de70ed75f01902d552594ccac990cba5b24" => :yosemite
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
