class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.1.103/squashfuse-0.1.103.tar.gz"
  sha256 "42d4dfd17ed186745117cfd427023eb81effff3832bab09067823492b6b982e7"

  bottle do
    cellar :any
    sha256 "7e2e0499c0b9f98beb398319c949d2a1d45de6a3f0b546ef1d55214f68522312" => :catalina
    sha256 "f4cb4305f7773fbf927d51a401453c3cdee1f1d48da2ef33d8fd41d526fa7c0d" => :mojave
    sha256 "ada7e939ff42fcd9fb6b1fb81ab596463d6149ff592f73ca924b5b9dca5ddfc4" => :high_sierra
    sha256 "c1898c81ae091097ae2502ecbdebdd1831db302dd74b814003191007a4d5f018" => :sierra
    sha256 "bf4e6ca88d094fd7d92fbab61dd1c3a4e71b60d7668d23b6044c90e8167833c5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on :osxfuse
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zstd"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # Unfortunately, making/testing a squash mount requires sudo priviledges, so
  # just test that squashfuse execs for now.
  test do
    output = shell_output("#{bin}/squashfuse --version 2>&1", 254)
    assert_match version.to_s, output
  end
end
