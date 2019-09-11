class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs-2.10/sshfs-2.10.tar.gz"
  sha256 "70845dde2d70606aa207db5edfe878e266f9c193f1956dd10ba1b7e9a3c8d101"
  revision 1

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

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
