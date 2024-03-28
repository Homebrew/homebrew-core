class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/debian/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.3.1.orig.tar.xz"
  sha256 "5a6d48bf1f60cfd3c32eae05b535b334972c1e9d4e62ed886dd54e040e9c1cda"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/r/reprepro/"
    regex(/href=.*?reprepro[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ae8f574c8fbfa13776901135cf93d2764d7fc039d7ab6727c959310785769b6"
    sha256 cellar: :any,                 arm64_ventura:  "074ecc0f03f9b65eee888d3c80da0b236267cea25fdca49f6a77f25da6bbcb45"
    sha256 cellar: :any,                 arm64_monterey: "4bd034f17d9a86c6e85173977ad58cbb2affa18678bd471b35216337be0f050f"
    sha256 cellar: :any,                 sonoma:         "4b6b3e4d96f54fefc29c8708115b720aed7af8390a11e4527a09adf7d1613512"
    sha256 cellar: :any,                 ventura:        "bb3fdf9b10d2edc35f84e82a851cb819aa1a1ba9cba1694ee98c17ef9c5a8e51"
    sha256 cellar: :any,                 monterey:       "57d484a17dd70a259e33c8f6b74abba671f6fc689fc09ef8c8c00df1ee83f271"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a79848562e65bd88dce7a8753728ac529fd080a20b36e40a1a58cccbc6f110f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db@5"
  depends_on "gpgme"
  depends_on "libarchive"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "No support for GNU C nested functions"
  end

  def install
    system "./autogen.sh"
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
