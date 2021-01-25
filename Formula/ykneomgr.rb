class Ykneomgr < Formula
  desc "CLI and C library to interact with the CCID-part of the YubiKey NEO"
  homepage "https://developers.yubico.com/libykneomgr/"
  url "https://developers.yubico.com/libykneomgr/Releases/libykneomgr-0.1.8.tar.gz"
  sha256 "2749ef299a1772818e63c0ff5276f18f1694f9de2137176a087902403e5df889"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "d08813317ba58b25a12d90485c20e372922bde6bda948a4b4979eccb07374e5f" => :big_sur
    sha256 "75e8cb3042d639b8271057b9d3e77c2786e66527a8c8602709dff4624b06d134" => :arm64_big_sur
    sha256 "583b882ed5705cfbde73f815689c7fcf70aec84b42a8de606dd847f99afc93b7" => :catalina
    sha256 "0fee721a06b166425760bdc5b65349f374ac6512ce09404cdc2c4d82f621022e" => :mojave
  end

  head do
    url "https://github.com/Yubico/libykneomgr.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
  end

  deprecate! date: "2020-12-28", because: :deprecated_upstream  # ... in favor of ykman

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
    assert_match version.to_s, shell_output("#{bin}/ykneomgr --version")
  end
end
