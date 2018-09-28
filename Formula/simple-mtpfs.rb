class SimpleMtpfs < Formula
  desc "Simple MTP fuse filesystem driver"
  homepage "https://github.com/phatina/simple-mtpfs"
  url "https://github.com/phatina/simple-mtpfs/archive/simple-mtpfs-0.3.0.tar.gz"
  sha256 "5556cae4414254b071d79ce656cce866b42fd7ba40ce480abfc3ba4e357cd491"

  bottle do
    cellar :any
    sha256 "a393f294fa56695eb464e64898e3607415a3de01b223576cf5d9e9571b2d5a8c" => :mojave
    sha256 "799625dbb36244feab3e209487c12d99467960ac14e80017552dbdd6a4f42ab9" => :high_sierra
    sha256 "e73ec4a78592b0fc76d86d3027615e2e8addc8b9a30da9caad433b2d1fced262" => :sierra
    sha256 "947d0e96fd262e1d493662955b3eb27e247d3fc52ed1e8dc07e58a4fb167892f" => :el_capitan
    sha256 "64c1df0ab967904c00f8b61d41bd4de70ed75f01902d552594ccac990cba5b24" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmtp"
  depends_on :osxfuse

  needs :cxx11

  def install
    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "CPPFLAGS=-I/usr/local/include/osxfuse",
    "LDFLAGS=-L/usr/local/include/osxfuse"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"simple-mtpfs", "-h"
  end
end
