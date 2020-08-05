class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmp/xmp/4.1.0/xmp-4.1.0.tar.gz"
  sha256 "1dbd61074783545ac7bef5b5daa772fd2110764cb70f937af8c3fad30f73289e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dc4399be2df77f0534bf1151201fd52b61694df7285bd58d9c1fe16522f199f6" => :catalina
    sha256 "197be59a2a0c3495aeed49eeeedea65b060534f4ff5ad234cdd35f6da19fb9e1" => :mojave
    sha256 "c76b4335844295d6daaaaca97f462828d39a9ce511c859d0ebf66165b12a6354" => :high_sierra
  end

  head do
    url "https://git.code.sf.net/p/xmp/xmp-cli.git"

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
