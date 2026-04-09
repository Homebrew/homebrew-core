class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.6.1/squashfuse-0.6.1.tar.gz"
  sha256 "7b18a58c40a3161b5c329ae925b72336b5316941f906b446b8ed6c5a90989f8c"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "dca859436a32269db6a94a7fd36284a86ad466bff008d7b56a555e72c15d49f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a02ea0c2e2ad0d15354c74b6dc3b55dd2f7f839ffd7592730e2049b6e60d0341"
  end

  depends_on "pkgconf" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "lz4"
  depends_on "lzo"
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zlib-ng-compat"
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
