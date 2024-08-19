class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.7.0/xrootd-5.7.0.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.7.0/xrootd-5.7.0.tar.gz"
  sha256 "214599bba98bc69875b82ac74f2d4b9ac8a554a1024119d8a9802b3d8b9986f8"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a1651db16a4cd1e1da3c2b06461994617feb5bae7594140af42c8f61d5e39dd0"
    sha256 cellar: :any,                 arm64_ventura:  "bf96d130c68e5ef5c147c83d2cedd519954ad4fdbec88b0832e6a71e58d92015"
    sha256 cellar: :any,                 arm64_monterey: "61b909503eb88d4a6ae3e72688881866c1b7b8775cae798b1052865bc6c5341e"
    sha256 cellar: :any,                 sonoma:         "71e41a87ac717fc7d509f88e8305f57329c2dff1e927b80c54b517d14166a198"
    sha256 cellar: :any,                 ventura:        "1d85108dec3b577ae4a91c01d8eb396be47a77a063903539a7934db5c87e9612"
    sha256 cellar: :any,                 monterey:       "7e947380f3782793248a1970d79ed71befa6721298ef98d003555cad708d5a3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3266fe8ecca6e2d469ece52f1e921030993e1ea9cee60f57ee80b0613ea5338"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPython_EXECUTABLE=#{which("python3.12")}
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

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xrootd", "-H"
    system "python3.12", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
