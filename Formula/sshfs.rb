class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs-2.10/sshfs-2.10.tar.gz"
  sha256 "70845dde2d70606aa207db5edfe878e266f9c193f1956dd10ba1b7e9a3c8d101"
  revision 2

  bottle do
    cellar :any
    sha256 "95ebaeb9f9416c60c6700597888a55fe6bb40b5c9f9559b6db5239872e326d14" => :mojave
    sha256 "9da72b32e4f155744f73cb71481519676dda245ba28d2cf63067a68902a478e6" => :high_sierra
    sha256 "a969b8cd9fd220281abd651a689892760ec16a09cf8253d1ca5a05eedb20f801" => :sierra
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
