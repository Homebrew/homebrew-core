class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.96.tar.gz"
  sha256 "e11a051f23701445ca99ff0bfbc4e49d8b87c66cdd04a68a1802c2613ba9e3f1"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "498ca33627f03956baf1e59675c0dcb84f714d541cd8a06a68927eb3d0949592"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "570753427deb94c2b35cce9af745c36b87c6ab1faebf20d860c180ad94ab6116"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "gnutls"
  depends_on "libfuse"
  depends_on "libgcrypt"
  depends_on "libxml2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "nettle"

  def install
    system "./autogen.sh"
    system "./configure", "--with-gnutls", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"s3fs", "--version"
  end
end
