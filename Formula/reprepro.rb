class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/brlink/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.0.orig.tar.gz"
  sha256 "5a5404114b43a2d4ca1f8960228b1db32c41fb55de1996f62bc1b36001f3fab4"

  bottle do
    cellar :any
    sha256 "0c031982eeb209bb7df512a9d80fbe90eea9bb1f1dfabe5239b99bd33807aa03" => :mojave
    sha256 "c1d32f22872c366dec7849f15b3a4c53787b7406e97df68545f150ce9f98ae98" => :high_sierra
    sha256 "5b0c6328f2cec66382e9202561e28b44ad61a03ad4b4f987d56467d523f00cfe" => :sierra
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
