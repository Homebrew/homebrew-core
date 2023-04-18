class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "https://xmp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xmp/xmp/4.1.0/xmp-4.1.0.tar.gz"
  sha256 "1dbd61074783545ac7bef5b5daa772fd2110764cb70f937af8c3fad30f73289e"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/xmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3ae0cdbec5798aa32c8672a6cf52fa6c149d8aba8fbeb33e8087a07db0178b87"
    sha256 cellar: :any,                 arm64_monterey: "3c26ef9b53e449f11014a97c30bdf8d81b09118bdb5a80f7ecc8088af44c0b31"
    sha256 cellar: :any,                 arm64_big_sur:  "a070ab6f7dc8b2c4177f11128d266b0ac606b7e8c252a320d2bf6a5be030d377"
    sha256 cellar: :any,                 ventura:        "8da6d8db5ad790cd922b6aaba9a0e0e914ffc6386a431dd76136e57bf20b0abf"
    sha256 cellar: :any,                 monterey:       "6799f4d2377cf20ecd85e76e7797d589602a98977c20cdbdf9503d390a38a12e"
    sha256 cellar: :any,                 big_sur:        "b4bf3702bd78bd9ce370c85978fa9cb822c4c77560f8cea753ec7098c13ab4de"
    sha256 cellar: :any,                 catalina:       "dc4399be2df77f0534bf1151201fd52b61694df7285bd58d9c1fe16522f199f6"
    sha256 cellar: :any,                 mojave:         "197be59a2a0c3495aeed49eeeedea65b060534f4ff5ad234cdd35f6da19fb9e1"
    sha256 cellar: :any,                 high_sierra:    "c76b4335844295d6daaaaca97f462828d39a9ce511c859d0ebf66165b12a6354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45355ca40a0109dd9f98a503886c820ca63bbc5e72585752571d67dda3573a62"
  end

  head do
    url "https://git.code.sf.net/p/xmp/xmp-cli.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxmp"

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
