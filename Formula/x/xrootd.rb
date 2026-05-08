class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.0.1/xrootd-6.0.1.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v6.0.1/xrootd-6.0.1.tar.gz"
  sha256 "79d73179e518f0c73c52e2ddac81fd66cf6df02e81609819ef9eba754dd1bb62"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac21f2f20ff8c04424c9bc25f14ab23c2da68f58dc2a622465dac09b83a8f341"
    sha256 cellar: :any,                 arm64_sequoia: "7082154f4a490366408812af8598b3dc8541babf014c8ee5527301e8684e1976"
    sha256 cellar: :any,                 arm64_sonoma:  "8fece99d1d2b0094a8ecd7a3a3501a684c751083281cc38bc980cdef703ea598"
    sha256 cellar: :any,                 sonoma:        "56f0beeb5e8ce70d9857f390c910cc6fd2686eab070a62a0fecff2a94040bee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a563ce998dc49f28cde8dcac8c3d614f6dd8c1ae8c1b223a7d9eb1f16fc6db8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c2f4e5de12bd0257cf67a9736355672567b116b7dedf8d10e5094bd5228c69"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "libzip"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def python3
    "python3.14"
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
      -DPython_EXECUTABLE=#{which(python3)}
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
    assert_match version.to_s, shell_output("#{bin}/xrootd -v 2>&1")

    system python3, "-c", <<~PYTHON
      import XRootD
      from XRootD import client
    PYTHON
  end
end
