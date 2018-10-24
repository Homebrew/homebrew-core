class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.84.tar.gz"
  sha256 "39b844fe94b44af48ab8d57645a0a3fd9a64486bb54413ba7f928111cb4093a3"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    sha256 "dbaec4af37a9dbfa1907b2d68f50cc4ca4fb71153f33c768a65f129ecc281185" => :mojave
    sha256 "92b9e79dc1d0422f2d9b0acf78cc7a0525a65bb86e9c2420d7bb32ff3bedb589" => :high_sierra
    sha256 "9e307d0ddd940c86fee609493f7b9d4539ee1949b8915eb34bc575249769df2f" => :sierra
    sha256 "d375bdefb6de55ae1793ef7e05f99e52c93be2b9500c9b5bba7f55ae57091efe" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "nettle"

  depends_on :osxfuse

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Be aware that s3fs has some caveats concerning S3 "directories"
    that have been created by other tools. See the following issue for
    details:

      https://code.google.com/p/s3fs/issues/detail?id=73
  EOS
  end

  test do
    system "#{bin}/s3fs", "--version"
  end
end
