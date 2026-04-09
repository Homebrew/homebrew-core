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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6172bb6e3ed24a3262ba0347cd673cff1c21aa9070a19e19fd0080a824249827"
    sha256 cellar: :any,                 arm64_sequoia: "3e5e78adbbf2fe3b280ad12b0c0280cc111cdbbe969d2f8d351e38a1ceb2d898"
    sha256 cellar: :any,                 arm64_sonoma:  "71cb5d6c6c730747893a2824d488915df53b9ab2363db85151fffeb988e23d35"
    sha256 cellar: :any,                 sonoma:        "f6c637c7a806b7593e34aabe0fd9a48e325c0badf49bc4ee832fa7e6daa0d94f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e597daa3f957ba29c07f0d49e3248304498da424db9a412f52786a8a59b16a0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc1062a1b192a2454bcde2ed80996bebba8d6561382b19309b2e307fcb30786"
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

  on_macos do
    depends_on "gcc"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
