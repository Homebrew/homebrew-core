class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs-2.10/sshfs-2.10.tar.gz"
  sha256 "70845dde2d70606aa207db5edfe878e266f9c193f1956dd10ba1b7e9a3c8d101"
  revision 2

  bottle do
    cellar :any
    sha256 "aceff3131dd0b098bdef8b5dda54d117b5dd5269ca146f7a5032ecde3c99b6d2" => :catalina
    sha256 "5f69267c0f1f2489989e108919d66210e058423d0d1f1661812c0194b164619c" => :mojave
    sha256 "58d222f37622b399352f16eaf823d3e564445d9e951629e965281ac31de5ef4a" => :high_sierra
    sha256 "dc4a7f24c2cbebd7c35891200b043d737ba6586a28992708ef849ffedff7bb01" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :osxfuse

  # Apply patch that clears one remaining roadblock that prevented setting
  # a custom I/O buffer size on macOS. With this patch in place, it's
  # recommended to use e.g. `-o iosize=1048576` (or other, reasonable value)
  # when lauching `sshfs`, for improved performance.
  # See also: https://github.com/libfuse/sshfs/issues/11
  patch do
    url "https://github.com/libfuse/sshfs/commit/667cf34622e2e873db776791df275c7a582d6295.diff?full_index=1"
    sha256 "6a121d58a94cf0efebbfa217d62aa4d9915a8e6573ae2c086170ff9d9fc09456"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
