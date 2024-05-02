class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.9/xrootd-5.6.9.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.9/xrootd-5.6.9.tar.gz"
  sha256 "44196167fbcf030d113e3749dfdecab934c43ec15e38e77481e29aac191ca3a8"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "749426498af0929373093f03d569d366af84235ef588a3f7dc567984bada6c10"
    sha256 cellar: :any,                 arm64_ventura:  "f373ffe1a043ed8a9ccdbcee92c1a3bb9815c90b1ef8b76c1c7f7fe4a3112a66"
    sha256 cellar: :any,                 arm64_monterey: "a0d28194a21fcf7095fb21f87c2084f1527328dba598d71076e38bd3b1e79126"
    sha256 cellar: :any,                 sonoma:         "d839deee85ab77a90ca252790f9423b6e12951f48250035f0717af86c461754d"
    sha256 cellar: :any,                 ventura:        "566b484124cd71de7dd352fa5266449ae96bb5a17256a642e04937780cd77bdf"
    sha256 cellar: :any,                 monterey:       "67f03d5ba7558359b5f298430269e4e49cdcec6b2bad31bb9498272843892763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ecd2c0d8085f6032a37341cb551d60db0d5c1ab47778cc6f083a7029ab46c62"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"

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
    system "#{bin}/xrootd", "-H"
    system "python3.12", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
