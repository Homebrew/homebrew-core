class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/brlink/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.0.orig.tar.gz"
  sha256 "5a5404114b43a2d4ca1f8960228b1db32c41fb55de1996f62bc1b36001f3fab4"
  revision 1

  bottle do
    cellar :any
    sha256 "6c95891ff569737d0b636f74456b3194571b4b3b5ef3e781dde572317f58e941" => :catalina
    sha256 "0fe440a480fa2c723af48142ca77b2cc5fb733ba5e20c011f90c11a0a1f221a0" => :mojave
    sha256 "dfeae3f34e3cf85ed2a5242f2b692a647935b78bae036398e02595448eb82e69" => :high_sierra
    sha256 "6ab79c20ca3f9fc1d020edcc6909af83346501656a9918e0dee1d2b9ee260016" => :sierra
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
