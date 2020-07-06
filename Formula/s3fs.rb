class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.86.tar.gz"
  sha256 "9cf7ffc8f48cedd70e3fd4fd97e8d6d049d8d370867df10ceb7630b5bc1a9662"
  license "GPL-2.0"
  revision 1
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    sha256 "7bc2ba3372d2e56dcd55ac551ce2e437590b7ce4abd88258a5140decf873ce06" => :catalina
    sha256 "76341907f7148b478881c1784a9a9d5d02327877155d8c8f93d66eb963d4e4d3" => :mojave
    sha256 "c26a27153d6fc99f4ea7c7a4c8fc51bd1e9e7109a151b8500e10bc7a129d74bc" => :high_sierra
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

  test do
    system "#{bin}/s3fs", "--version"
  end
end
