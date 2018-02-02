class Ykneomgr < Formula
  desc "CLI and C library to interact with the CCID-part of the YubiKey NEO"
  homepage "https://developers.yubico.com/libykneomgr/"
  url "https://developers.yubico.com/libykneomgr/Releases/libykneomgr-0.1.8.tar.gz"
  sha256 "2749ef299a1772818e63c0ff5276f18f1694f9de2137176a087902403e5df889"
  revision 2

  bottle do
    cellar :any
    sha256 "35d3a87c9eff5d84fd8dbf3fc2cf9175ab69fd450b691c6f19ca3a1f8b9486ad" => :high_sierra
    sha256 "749b6ae84f03c659f55d6086994e86b93250c80e75c95535e1bba2e988734846" => :sierra
    sha256 "6635df6c9ced211112593d03a1faa6b913a0bfb697b5e3b198dad67f061b5573" => :el_capitan
    sha256 "6b333a6688997a75a718d034059d7318fe2a02fe7d2a9078decf8a48283f85de" => :yosemite
  end

  head do
    url "https://github.com/Yubico/libykneomgr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt" => :build
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "libzip"

  def install
    system "make", "autoreconf" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "0.1.8", shell_output("#{bin}/ykneomgr --version")
  end
end
