class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.0/xrootd-5.6.0.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.0/xrootd-5.6.0.tar.gz"
  sha256 "cda0d32d29f94220be9b6627a80386eb33fac2dcc25c8104569eaa4ea3563009"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c94214d8c0b9db2204b09d52ea4118cb8120989b1baa5b1624b62855b290888e"
    sha256 cellar: :any,                 arm64_monterey: "4bb86063c48de34a337f769493f63480854062ac1e9b66e23be5c206594d362b"
    sha256 cellar: :any,                 arm64_big_sur:  "7cc6b588f5f65b125bf0a16d9b35b63ddcc817f7f82dc863882cc50eb3557763"
    sha256 cellar: :any,                 ventura:        "8185fd285c255d97efea5e3672a3d50b3b8bae7636d0543c00d12736c8d5416c"
    sha256 cellar: :any,                 monterey:       "0af97e501a6905a02d43e4e56189a478efa61617dabd63714d3dad4cdfcc2faf"
    sha256 cellar: :any,                 big_sur:        "868636eb73b8cc6ecd8d72e7ec024b0f1c88ba3ad08d7b4fe6d743f6ae228477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "438eb3025a56fb23c62911fb8695bf1e6f8a471bc2b8bddf8536c4e8e10c1e3f"
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
