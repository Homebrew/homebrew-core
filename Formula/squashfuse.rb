class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.1.104/squashfuse-0.1.104.tar.gz"
  sha256 "aa52460559e0d0b1753f6b1af5c68cfb777ca5a13913285e93f4f9b7aa894b3a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b55b7786381a508c76bfe3d278e2a669d28755ec59d458a728fd12b760802d2a"
  end

  depends_on "pkg-config" => :build
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "lz4"
  depends_on "lzo"
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zstd"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Unfortunately, making/testing a squash mount requires sudo privileges, so
    # just test that squashfuse execs for now.
    output = shell_output("#{bin}/squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end
