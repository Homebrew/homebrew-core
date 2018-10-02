class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/libfuse/sshfs/releases/download/sshfs-2.10/sshfs-2.10.tar.gz"
  sha256 "70845dde2d70606aa207db5edfe878e266f9c193f1956dd10ba1b7e9a3c8d101"

  bottle do
    cellar :any
    sha256 "e4c05b69dfe45387aa294ca3fa675cf487db6c99b795859730ec6900fa61ec46" => :mojave
    sha256 "283859a4868df7d91fc4a6fcef6ddc590957a661f833fbf81da25f6f2c72a585" => :high_sierra
    sha256 "534fc64f25ee6757e4fd802988deee9d2df8f1c38604d36c525a12a67b1d23fa" => :sierra
    sha256 "27c5e0d7f9bed4219c12267bd459fbd25a143abf0a9e3f5fa12fd0b587f10007" => :el_capitan
    sha256 "61c578fbd666a6c2b5b452a7429e3fd5a64da153652d428386c41b4ebb6e30fa" => :yosemite
  end

  option "without-sshnodelay", "Don't compile NODELAY workaround for ssh"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :osxfuse

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-sshnodelay" if build.without? "sshnodelay"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end
