class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/xmp/4.1.0/xmp-4.1.0.tar.gz"
  sha256 "1dbd61074783545ac7bef5b5daa772fd2110764cb70f937af8c3fad30f73289e"

  bottle do
    sha256 "4eb53e6f831785a5bbe084be7be3c83c7942392c06a00608f8d4d29e0d0d735a" => :sierra
    sha256 "2412ab978ad3562876d8078a6e588f8617b5507df33aecee84ada484f1ec33b8" => :el_capitan
    sha256 "a0ee59b4a71a7cda6a59e7b06a9c0b54dc04e3bf77b97f0b4e2336c16afc8d57" => :yosemite
    sha256 "289fbcb9393539a355bf163dce53562afd29981c2fd0de3491133c7105a5bc06" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/xmp/xmp-cli"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxmp"

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
