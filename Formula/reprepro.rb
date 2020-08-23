class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/brlink/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.0.orig.tar.gz"
  sha256 "5a5404114b43a2d4ca1f8960228b1db32c41fb55de1996f62bc1b36001f3fab4"
  revision 2

  bottle do
    cellar :any
    sha256 "b4588ca9f8be12fdf56fe66d846ef9dc0c0508fd436fbb3065c0009b7bcd6939" => :catalina
    sha256 "70363262c41a09895d4d43a2bd25302ed76e9e9d187edde3512ec917e5a96b48" => :mojave
    sha256 "86a0418ad19243949f1dbfb621970022fab9eb409c5690e4bca2d12f441644dd" => :high_sierra
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
