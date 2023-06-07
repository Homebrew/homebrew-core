class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/brlink/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.0.orig.tar.gz"
  sha256 "5a5404114b43a2d4ca1f8960228b1db32c41fb55de1996f62bc1b36001f3fab4"
  license "GPL-2.0-only"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58280d22109eadb3d07036d81afe3a9d0a1eb5b0cc6433993ea072bec7bb597a"
    sha256 cellar: :any,                 arm64_monterey: "e915fdd76e80343ba05cad6f9a914f9b60f4542f3e7960c670356b7fd0d98b5d"
    sha256 cellar: :any,                 arm64_big_sur:  "23db5bfd409b0976b8ef34417dcf9c1978180d691a7cd2700022dcd5dfed5967"
    sha256 cellar: :any,                 ventura:        "856e70889d4ab149bea1b24b7af3145ff6e9b7d1ff226889bcfb9854a715a23c"
    sha256 cellar: :any,                 monterey:       "58dd7d17fb51befa9c6631a2da3db17ba8b78036d6e465bc41b9823359a8e9f4"
    sha256 cellar: :any,                 big_sur:        "3dbf660c420d129cdf9dcbc4ec8b53ede30beabb269c4dcc320ee3dbee77158b"
    sha256 cellar: :any,                 catalina:       "f52c6ba27a0f1f0d979ba890cd8a11b916afeed5b581cad08fa788d2d5d10a43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "083ddcc7baec64baff8ebe0ebabdfe14debf27f38f8ee86b588d52d9b3bbed39"
  end

  depends_on "berkeley-db@5"
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "xz"

  on_macos do
    depends_on "gcc"
  end

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
