class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.7/xrootd-5.6.7.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.7/xrootd-5.6.7.tar.gz"
  sha256 "4089ce3a69fcf6566d320ef1f4a73a1d6332e6835b7566e17548569bdea78a8d"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1de3d9f86ec96ac76987707d7535b47eddf7f0d0fe304e2a30bf9fa111a5c719"
    sha256 cellar: :any,                 arm64_ventura:  "09225bf0226a5f8fc611a360a241fa4c1ff4623bc69568a2ab896cf6f47fe14c"
    sha256 cellar: :any,                 arm64_monterey: "e0f4d1a245c9c23ecd2475242e5681346fb2c00db28dae9378c7338a6a2b0f35"
    sha256 cellar: :any,                 sonoma:         "52b6f3b22d1b3a79a2f79004f51b8c2ebe39b14145b8996bb13cee06cb59e676"
    sha256 cellar: :any,                 ventura:        "a574ef24e01cd5a8b9b1b61525bb0240025a01d5a0841d188949c9f4784c4ec0"
    sha256 cellar: :any,                 monterey:       "acc6b0cc65dec5a5ec2da315bab1dd76e23db458f5fd4010e393bf3d17178a36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b8dffd67b3f3d7d7ecd0364fa7faade20f7bc82a42252fdaaa4decc707db7e7"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
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
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_CRYPTO=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
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
    system "python3.12", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
