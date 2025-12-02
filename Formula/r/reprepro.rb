class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/debian/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.1.orig.tar.xz"
  sha256 "5a6d48bf1f60cfd3c32eae05b535b334972c1e9d4e62ed886dd54e040e9c1cda"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/r/reprepro/"
    regex(/href=.*?reprepro[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b5855ee25ccd87bcbc2a4625fa0277603efd7009c52c318f3f8ca12a29470da"
    sha256 cellar: :any,                 arm64_sequoia: "8eaef64ed0c0e9f094a22ac31fe47363d49231963ee63dc9f0378f78e4090da6"
    sha256 cellar: :any,                 arm64_sonoma:  "80efe269819b4ec7ff59218ea83c67374ad62869cd523fd3bcbc23a68a382195"
    sha256 cellar: :any,                 arm64_ventura: "679cf41e7adc1e217f128f1b327afe9c36ff157b5f3bcfbb311f5303a0884b88"
    sha256 cellar: :any,                 sonoma:        "fbb7034959d348763e3eb3c08e64075d36c9fafd5ce59bdfb8d97649935f6b5f"
    sha256 cellar: :any,                 ventura:       "d4ebe5c1ab2c0bccf82f799081b90d85f11ef1691c74118722865bafbbad7f51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "564f8477e018c4640f5d62bd266440d63d13d0d9a3972000e3094d0f85f0749a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47d8665481d35d31fec110327e4c2d9c23629d3e18debee80d91c907a371dacf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db@5"
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "libgpg-error"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "No support for GNU C nested functions"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-gpgme=#{Formula["gpgme"].opt_lib}",
                          "--with-libarchive=#{Formula["libarchive"].opt_lib}",
                          "--with-libbz2=yes",
                          "--with-liblzma=#{Formula["xz"].opt_lib}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"conf/distributions").write <<~EOF
      Codename: test_codename
      Architectures: source
      Components: main
    EOF
    system bin/"reprepro", "-b", testpath, "list", "test_codename"
  end
end
