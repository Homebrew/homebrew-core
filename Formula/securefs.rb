class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.8.3.tar.gz"
  sha256 "04b0aa78108addcdeef64a4333ac75dff2833b7a48797b7c9060e325520db706"
  head "https://github.com/netheril96/securefs.git"

  bottle do
    cellar :any
    sha256 "e6265b4ba4a645c32443bca939f1fda8e6a47cdbf5807efa6efcebd5b19fd5b9" => :catalina
    sha256 "07605d0d88a95902f1ee39d88c56dceadcacdf6e61a71431f68cdbf97003c848" => :mojave
    sha256 "e0a3b66b2dd99a8cd2a6f79b4fe537875c55aa240f7383bef450b008fff6dfff" => :high_sierra
    sha256 "a75071f5711a298f0223c4776891c2ccd5062f0a2830debfaa0191a0152d8bfc" => :sierra
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
