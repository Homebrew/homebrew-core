class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.87.tar.gz"
  sha256 "c5e064efb8fb5134a463731a7cf8d7174c93a296957145200347d2f4d9d11985"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  bottle do
    cellar :any
    sha256 "5183ab606057fbe8e46a737b25c1ad4e82dd67389f48827d7bfd567c67cf8417" => :catalina
    sha256 "d691bdeb4abd443bc1f1f3de46c286a97829f95ba3d47b026e535a6688085d07" => :mojave
    sha256 "f475d03b68102dd400a22de99b9ddc044653f6658e2cb84349adf507ffbddcad" => :high_sierra
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
