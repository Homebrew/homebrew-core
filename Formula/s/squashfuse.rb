class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.6.1/squashfuse-0.6.1.tar.gz"
  sha256 "7b18a58c40a3161b5c329ae925b72336b5316941f906b446b8ed6c5a90989f8c"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "2ac81c35fe8e2339d2da50ba09484eff8f69552fb3f501f33d8df133d358173a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a8f4cd10ca2e0d20f7407ba2d8fa8240d3786dd4c65b40f1e24a7878e0f828e4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "lz4"
  depends_on "lzo"
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zlib"
  depends_on "zstd"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Unfortunately, making/testing a squash mount requires sudo privileges, so
    # just test that squashfuse execs for now.
    output = shell_output("#{bin}/squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end
