class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.9.0/xrootd-5.9.0.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.9.0/xrootd-5.9.0.tar.gz"
  sha256 "e08e6fc73aeab08e56f716adafa9476cdfd293e28c14d0af5b1a67c06b1e6831"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "3c1bd70828213956662a25df2ad7fcc7fdda2a53c2d94b60065f2e6e3ca7e302"
    sha256 cellar: :any,                 arm64_sequoia: "6e0505dddd88bc2133641506ee5db0326366bea061e5b7ed4005e2ee7e369aa2"
    sha256 cellar: :any,                 arm64_sonoma:  "2bbe7b565d73a18f075d9f4cdb31aab74dabbe2a845dc8cfb196002270ce96ea"
    sha256 cellar: :any,                 sonoma:        "7a50482ab6d748f862034fbb40fb871c304955c061b0314d9adf6d1abdb58d6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "affd7d3ddcb18bf3c7548823cf9805a6f498f837ea9ea526d688d6c1fbdd1a0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4426026838084d73ab75b25b12c498b3e68268b4b525cff8250a14b0616b900a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
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
