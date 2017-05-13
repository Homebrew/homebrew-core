class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.6.1/xrootd-4.6.1.tar.gz"
  sha256 "0261ce760e8788f85d68918d7702ae30ec677a8f331dae14adc979b4cc7badf5"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "400096169e1b4f744ccc421c45403edeac0454ba2349ec8397387290cf3f6881" => :sierra
    sha256 "b36e30eb719766732cf0dead5f60a58cf14c704f39ecd6c3d7e4f7f9b95d3b13" => :el_capitan
    sha256 "65afafc95ec4869cb958e99c6c751e30de4bcc60163cee547ec6bbf39e4db591" => :yosemite
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
