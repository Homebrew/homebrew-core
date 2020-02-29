class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.11.2/xrootd-4.11.2.tar.gz"
  sha256 "4620824db97fcc37dc3dd26110da8e5c3aab1d8302e4921d4f32e83207060603"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "5831ac792d823042cffdf77133967f581b2158ab480372bb23e14124e56f58e1" => :catalina
    sha256 "6de06329afe997a6170e1953ed3c0d7d220ee165dc9bf3696b2744b8e63b7e12" => :mojave
    sha256 "c4acb024c20c2b24f2b6be341ca488d6f0f097fe03313454132bfe4cac5b0189" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
