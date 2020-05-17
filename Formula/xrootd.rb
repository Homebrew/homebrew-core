class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.12.1/xrootd-4.12.1.tar.gz"
  sha256 "7350d9196a26d17719b839fd242849e3995692fda25f242e67ac6ec907218d13"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "ca8bf41840e9be4351c25f309af3c51075c1c7ec34a8ac1d36e53d5956a3f5d1" => :catalina
    sha256 "43f4f1fbb893a02accef9afbcec430b6045ab88fa25cf3990b38450c47027a42" => :mojave
    sha256 "21f2b97f720a1d70142cdd945130cfcc75b8d5b2f56d867aac527c2485928eb1" => :high_sierra
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
