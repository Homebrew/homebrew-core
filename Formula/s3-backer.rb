class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://github.com/archiecobbs/s3backer/archive/1.4.3.tar.gz"
  sha256 "bf095e41b368067c766c0831e088e1e93411e29f4482efadaaf44e699ada16f6"

  bottle do
    cellar :any
    sha256 "64df94342e386fa4163eba7f44fb3fa8104ae702ef4649e72530ec0a01a67221" => :sierra
    sha256 "96f82aa40f55286359f3a5c4866eb84a15491b979fc78788eb16cf82bd89947d" => :el_capitan
    sha256 "33fbbf30c5ce36a3d522e55df99b3fa15c2494b1f3d835ae267e44b77c033827" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse

  def install
    system "./autogen.sh"
    inreplace "configure", "-lfuse", "-losxfuse"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"s3backer", "--version"
  end
end
