class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/brlink/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.0.orig.tar.gz"
  sha256 "5a5404114b43a2d4ca1f8960228b1db32c41fb55de1996f62bc1b36001f3fab4"
  license "GPL-2.0-only"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f14b3e3317912d4419c020aa99921c4bbd646c111f5913d2b1f89cd4e0e3d6f5"
    sha256 cellar: :any,                 arm64_big_sur:  "9c34c0ab99f6bb2c689e25b10e6f17d41b37f417d5eeff739d192694aa932810"
    sha256 cellar: :any,                 monterey:       "b5f8b1eac94f1f282d21473bc59e6df5a768af8e3a46bd27dd2083f6f97086aa"
    sha256 cellar: :any,                 big_sur:        "c30c645de4d6279401c622e7b26523c7d2aa322f8315043947c19a5e40ea9ff2"
    sha256 cellar: :any,                 catalina:       "e686c334946418c6cf450c412ac0e40107a644f2e33d896842a30a74ee21d9b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3aa207822242a14ce2996495fe313a6902672ad4543290aae97e617a5dc104"
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
