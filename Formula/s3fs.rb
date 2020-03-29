class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.86.tar.gz"
  sha256 "9cf7ffc8f48cedd70e3fd4fd97e8d6d049d8d370867df10ceb7630b5bc1a9662"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    sha256 "e3b74483ce30b458f31ad9b8954589dd1745d3952b52aca65c59bb8e1e147b3d" => :catalina
    sha256 "5c5b9eecee40292e57fee4729de3df4d12f3d0a089f0d77d8b275d6115c91bd5" => :mojave
    sha256 "532ddbe33e92d9e4b83e5459500642169a0e59eb4771e12f20f8df3307e131f8" => :high_sierra
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
