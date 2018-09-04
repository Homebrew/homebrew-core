class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "https://downloads.sourceforge.net/project/x3270/x3270/3.6ga5/suite3270-3.6ga5-src.tgz"
  sha256 "bebd0770e23a87997fe1d2353e4f1473aabe461fdddedccbb41fd241e8b5b424"

  bottle do
    sha256 "910ce0d5e1b99a3bf06f74da9a73bca06478e2b18a719b1b9b7d2f45d50eeda4" => :mojave
    sha256 "f67129f6e0d14448939953d4c8966a5770d8a65aecdf42108f43dd4914dda9d8" => :high_sierra
    sha256 "08de119ad4c2626d8f8b5da84976601b89f1428af4274c2f5e1ed48b3805254d" => :sierra
    sha256 "c82c4f5ceb379a44acab4592f3d1d9cd05d499541b806397bd656e2152474815" => :el_capitan
  end

  option "with-x11", "Include x3270 (X11-based version)"

  depends_on "openssl"
  depends_on :x11 => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]

    args << "--enable-x3270" if build.with? "x11"

    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
