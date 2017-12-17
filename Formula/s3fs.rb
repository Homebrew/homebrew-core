class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.83.tar.gz"
  sha256 "8f060accef304c1e5adde0c9d6976a3a69fd9935444a4985517c6cefa86b34ef"

  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    sha256 "a2561b0db0c7eb9a4355b42a38f307f4e432da3db3b3580a68eeee8001b12ffd" => :high_sierra
    sha256 "d6b4884bb5138ff0f10f2149668b09685567c8f55069525ec5557f54033d191f" => :sierra
    sha256 "9dcbe3450e2fdf5498c18e11390c9d48474c91c1bcd4f8cad6a7e3057fb9b3ee" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls"
  depends_on "nettle"
  depends_on "libgcrypt"

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
