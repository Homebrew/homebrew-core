class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.11.1/xrootd-4.11.1.tar.gz"
  sha256 "87fa867168e5accc36a37cfe66a3b64f2cf2a91e2975b85adbf5efda6c9d7029"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "6ddd6b2fae855806a745afb4941d827f50449f92fc1b487082161f7ee3e69d9b" => :catalina
    sha256 "bd952b516cd0f29d6baef29720a1d3f4fcc43b10e04e44baa33b2079c1d0772e" => :mojave
    sha256 "23344eb8a2084a805b95e18176321e426d086e39570243ee1ec7dbfa26a8c7ee" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

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
