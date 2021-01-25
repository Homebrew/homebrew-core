class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/brlink/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.0.orig.tar.gz"
  sha256 "5a5404114b43a2d4ca1f8960228b1db32c41fb55de1996f62bc1b36001f3fab4"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "9f87049de8d9c70a38429e5fc56173cf41e598621a6de661fdc1465bf28b8819" => :big_sur
    sha256 "37ecc6897dce6d44e6a0b5965f3a7cc622a8e506d31482ade2a4f4f211c90a0b" => :arm64_big_sur
    sha256 "ce81080f227223229a9cc85126c5189d7bb8a0b12f928e5a1b71c48a0f0e4f88" => :catalina
    sha256 "4c69c6b440e77633069009ec48bb72739402052e4b4fff03504ab09bfcb88a56" => :mojave
  end

  depends_on "berkeley-db@4"
  depends_on "gcc"
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "xz"

  fails_with :clang do
    cause "No support for GNU C nested functions"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gpgme=#{Formula["gpgme"].opt_lib}",
                          "--with-libarchive=#{Formula["libarchive"].opt_lib}",
                          "--with-libbz2=yes",
                          "--with-liblzma=#{Formula["xz"].opt_lib}"
    system "make", "install"
  end

  test do
    (testpath/"conf"/"distributions").write <<~EOF
      Codename: test_codename
      Architectures: source
      Components: main
    EOF
    system bin/"reprepro", "-b", testpath, "list", "test_codename"
  end
end
