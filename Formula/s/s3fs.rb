class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://github.com/s3fs-fuse/s3fs-fuse/wiki"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/refs/tags/v1.97.tar.gz"
  sha256 "28413457cbf923b9b81e546caffabb8edd5c18f263e698ad86f564fd4b5b344d"
  license "GPL-2.0-or-later"
  head "https://github.com/s3fs-fuse/s3fs-fuse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "98936a769c49e9d9d7fe5e654304a08906a4fd9276f507d468f1d667a016528a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3fd8a38dd94f3523cfe03b544b4e12cd3dbfe724a34098c3e7373bbe799bee11"
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
