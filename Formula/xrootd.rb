class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.10.0/xrootd-4.10.0.tar.gz"
  sha256 "f07f85e27d72e9e8ff124173c7b53619aed8fcd36f9d6234c33f8f7fd511995b"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "c463897d0c849cc777661ea7dec042d8b10afffcdfc05bd11c12d41661d8e835" => :mojave
    sha256 "0a90dbb2c1c72dc991bbddbe3b2ccce0c6ba98e5a24708e96bd2f9b1b722cabf" => :high_sierra
    sha256 "0e4908491f16a3b7d02026f1bb09d8829830dccb4f0a3a7b83faaa6d1147d669" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "readline"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
