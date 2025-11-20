class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.95.tar.gz"
  sha256 "0c97b8922f005500d36f72aee29a1345c94191f61d795e2a7b79fb7e3e6f5517"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "00151c7e7b2a24b5b20c712cd15f8b2771d58aa938a7770f9c4b56b6159a22c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e9e579dcfd0eb03fbef71e9aba87673fe1ea4f4b84a5ea254df3af6a6fd19dfe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "gnutls"
  depends_on "libfuse@2" # FUSE 3 issue: https://github.com/s3fs-fuse/s3fs-fuse/issues/1159
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
