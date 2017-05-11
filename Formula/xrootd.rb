class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.6.1/xrootd-4.6.1.tar.gz"
  sha256 "0261ce760e8788f85d68918d7702ae30ec677a8f331dae14adc979b4cc7badf5"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "98956880d9cb2d36a4d2f32d04bf351d7f329e51fc639a15f77d91e982eb7a86" => :sierra
    sha256 "c4765937da5ae6637efd92c5c7b8a1adc57d801c61eb2a0e2252caa88d6567fe" => :el_capitan
    sha256 "692861333404f5936a0bf1dce7a4d4a3a7f04e34903e5c5e3716bb2dc5bb4d58" => :yosemite
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
