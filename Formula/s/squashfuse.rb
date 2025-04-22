class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.6.0/squashfuse-0.6.0.tar.gz"
  sha256 "56ff48814d3a083fad0ef427742bc95c9754d1ddaf9b08a990d4e26969f8eeeb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3eb9a638243d6c68329901cdc71fa5e5302b659d4559549764d604d55bf2355c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c247357fc40588fe09b20c1210247f90ed03265d2ca4572edc3ecdc2c5b2fcac"
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
