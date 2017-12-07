class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.8.1.tar.gz"
  sha256 "f116f7bf66a0f65fce8ca3536ca2768076281ae8851c00343caa68504c5449e8"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "6824b2cfcfdc55cc79d1e01d6a958d55c082533e74d697b1db77815083a1e31b" => :high_sierra
    sha256 "9a347b474fb48789d148e22ee2165224166c00161b2447cf2c6a8cf0a23326cb" => :sierra
    sha256 "b15c75803225335e0465ccd66215d09d8194ebb1320072020cf21189c34266b4" => :el_capitan
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
