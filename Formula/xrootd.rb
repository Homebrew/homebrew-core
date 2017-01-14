class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.5.0/xrootd-4.5.0.tar.gz"
  sha256 "27a8e4ef1e6bb6bfe076fef50afe474870edd198699d43359ef01de2f446c670"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bfd51945b51e87bb4216606888c55d0fbf56a4ac5882e8af6e17109d1ecc44bf" => :sierra
    sha256 "10019de1deb873bb5324d94ec6153dab41e537f1cdbab4eaf7c00f6de666e0d4" => :el_capitan
    sha256 "5aec9e2b8272937b9bfe807b0fe19ecbd80ee09cffb90199f4bacedafb4993c0" => :yosemite
    sha256 "dd7dc0728eb0117d8d0d544bc6ff20b460015d8e2cc6868c3ba5fd8c748716b7" => :mavericks
    sha256 "1b6edb252ed5915dc67b39dbe84500d9f36af0dc883e63dfcf724af59b35e6f5" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "openssl"

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
