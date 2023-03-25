class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.5.4/xrootd-5.5.4.tar.gz"
  sha256 "41a8557ea2d118b1950282b17abea9230b252aa5ee1a5959173e2534b7d611d3"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c5937c9f0e16c78dc35b6692808481c54cf51c2c5e82656db691d35be1131325"
    sha256 cellar: :any,                 arm64_monterey: "4df046cc23f695711375fde5fe00b240cbf121264d4a041d05740488bd75cae2"
    sha256 cellar: :any,                 arm64_big_sur:  "93576e8c90048cb768f5f50351657f524ada3bc4542f08ff01f44f2ac9188e9f"
    sha256 cellar: :any,                 ventura:        "73c3baafe5008641a6b2bdbf68e40a3b9fcf622545d2f3682dd1fc3381f5d7d0"
    sha256 cellar: :any,                 monterey:       "c6e339d4d6a19a5764c064422fd741ccde1f218ff525a5e8e6f1bf97539af17f"
    sha256 cellar: :any,                 big_sur:        "1df51eaca0cf91ab85498d05210bbfd2b4e19f05b1b96bf69f373d53f0deb94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e9abd6c5e46b9623892cdef2cc721812eeca1b1e3788891a9e8150cc843252"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_CRYPTO=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
      -DENABLE_READLINE=ON
      -DENABLE_SCITOKENS=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_VOMS=OFF
      -DENABLE_XRDCL=ON
      -DENABLE_XRDCLHTTP=ON
      -DENABLE_XRDEC=OFF
      -DXRDCL_LIB_ONLY=OFF
      -DXRDCL_ONLY=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/xrootd", "-H"
    system "python3.11", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
