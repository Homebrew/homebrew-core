class Reprepro < Formula
  desc "Debian package repository manager"
  homepage "https://salsa.debian.org/debian/reprepro"
  url "https://deb.debian.org/debian/pool/main/r/reprepro/reprepro_5.5.1.orig.tar.xz"
  sha256 "475754c864e3285ad77545792b3eae0196dbb3d01498fca5c5fb30b04a72a977"
  license "GPL-2.0-only"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/r/reprepro/"
    regex(/href=.*?reprepro[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d105743acb1ed3af2639fa57bc63d091887aafc27590b566010c3862f91f0831"
    sha256 cellar: :any, arm64_sequoia: "b706bf94071d033c83360f93fce6f18480a89585d5f151426de28c2cb6e3f4ba"
    sha256 cellar: :any, arm64_sonoma:  "ae0d23de7abe6d702f9b6ab2d5dd888ba98467bc79a8f020cd6b774aac07ef0a"
    sha256 cellar: :any, sonoma:        "4564c95512ce1c51464cc4c14cd99ddad4bbd9f8625f0d26865f08fe2479cbfd"
    sha256 cellar: :any, arm64_linux:   "af7b76a524ba1b8221feac874361bde901a90b908bb1c610b7ac83f7938bf992"
    sha256 cellar: :any, x86_64_linux:  "36e245d92ea74618d932d3780e092d01e56fe6b69e456075eb32a80a7921f7de"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db@5" # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1119179
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
                          "--with-gpgme=#{formula_opt_lib("gpgme")}",
                          "--with-libarchive=#{formula_opt_lib("libarchive")}",
                          "--with-libbz2=yes",
                          "--with-liblzma=#{formula_opt_lib("xz")}",
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
