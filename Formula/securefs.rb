class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs.git",
    :tag      => "0.9.0",
    :revision => "cf84306e616f04aa3845db25e446df0f7c21416a"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "62611abe101f437d98e59c4b2311abd5645c32c15b57f22f195bc01c7df1d586" => :catalina
    sha256 "7c9b57a3442b581e1a359035058e348fd51305e4c64113a16fb180c7932f96d9" => :mojave
    sha256 "ea14d7b4f0ba48c4bdea31f42b0eabfe727a8e54eee923ee570698b5e1d3779f" => :high_sierra
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
