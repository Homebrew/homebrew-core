class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs-3.7.0/sshfs-3.7.0.tar.xz"
  sha256 "6e7e86831f3066b356e7f16e22f1b8a8f177fda05146f6a5eb821c2fd0541c34"

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

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
