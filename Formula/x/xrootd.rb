class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.2/xrootd-5.6.2.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.2/xrootd-5.6.2.tar.gz"
  sha256 "7d7c262714268b92dbe370a9ae72275cc07f0cdbed400afd9989c366fed04c00"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87c77231be5cb088cce982292b9b013f72e9a3be85791e415247ed6f30048b9c"
    sha256 cellar: :any,                 arm64_ventura:  "7acb7f79182720a35dd96a893f49aedacb036536b0b286566c4eb6f058f0f43b"
    sha256 cellar: :any,                 arm64_monterey: "559ad3141c7f01748799dc03c502ff96b2967df3ef4a545e0207ee83b2acb45a"
    sha256 cellar: :any,                 arm64_big_sur:  "819954cc4b6b214f6af3a67d5b8a29948e43b7f4a3d3f038e8024e272ee50b06"
    sha256 cellar: :any,                 sonoma:         "de0df3a5fe90ad7201d851de4a56c443b63dac14842390b0c450069c8c87d7bb"
    sha256 cellar: :any,                 ventura:        "6495a734018e2ad94be300958b09774a281616801f3ab417c78ee561ab9b6c8b"
    sha256 cellar: :any,                 monterey:       "97f74537d663f8ee675f1739c9c16d5177e09be77f890a0874754393a4a67744"
    sha256 cellar: :any,                 big_sur:        "092f9c30f1234492f000e401cd156c5fa5122011d614d47198ce156afac252f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d78c2c832ad5833bc57ba580f6c43f51e929f3deb52e128337973d0f0aea2aa"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "util-linux" # for libuuid

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

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
