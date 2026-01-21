class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/debian/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.4.8.orig.tar.xz"
  sha256 "f25409cf50acfc8b01a8e1e7c4e176292107763beedb058b42d7bf8e56a8e9c2"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/r/reprepro/"
    regex(/href=.*?reprepro[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5e4f24abe9836969e7089bc7862bba0666f5c59b7332612f604d02a597960b86"
    sha256 cellar: :any,                 arm64_sequoia: "2baab6ad6ba965ea94537aad8d592612752d2aee1267240a3d101dd7f4df8f79"
    sha256 cellar: :any,                 arm64_sonoma:  "6a9d163e434e467024671e1c19cb2e14bfddcb84605e80ae8e4456275c2f07a9"
    sha256 cellar: :any,                 sonoma:        "5e8ea5e5fc80e440ef93cf8a61b90537fcafc150668d4c3cb7d473db2c5ba29a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "315a7155b8557e575cc84791abad4dafcc88ef4fbcd0e42d745c4079cf1b5b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8798fa0fd08a477f21852eeef3920f9a62618679fa7af97212622ef08026f0bf"
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
