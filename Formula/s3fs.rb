class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse.git",
      :revision => "a08880ae1580f3ab9a90d179180e05923d1af315"
  version "1.82.1"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    sha256 "1a696835e0c5305cc0f42d7571b2f027227b12a85ab3f866146b219bc6e68fb5" => :sierra
    sha256 "74f80941f3e02fdb0ae4aa548dc34815a101ae4fde820a12389d33b15edaf680" => :el_capitan
    sha256 "d0eff9a3aa81a038eab132fc3d8481580d7d14847d924658608bbd70e4bf6ce4" => :yosemite
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

  def caveats; <<-EOS.undent
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
