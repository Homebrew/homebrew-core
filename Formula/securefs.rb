class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.8.1.tar.gz"
  sha256 "f116f7bf66a0f65fce8ca3536ca2768076281ae8851c00343caa68504c5449e8"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "e4d89492ab25d93425d0b483c3b8b44d3b82a707ef98ce0fa8ad05a74f4ff96e" => :high_sierra
    sha256 "0e5ec538a9da8e9c002befd10578e783db1b61fd5351b4b6ee8de35bda81abbc" => :sierra
    sha256 "5066deb7e5876f9ac7f039f68984a15b0cca44b7a4303bd40318fd9019141415" => :el_capitan
    sha256 "98661d949df67ccfa5ea16eaf606a358f9e03d3b737276bf03ee4d65070905e7" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :osxfuse

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
