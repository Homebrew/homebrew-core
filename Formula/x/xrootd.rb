class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.org/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.1.1/xrootd-6.1.1.tar.gz"
  sha256 "2853c9fcf476c924f3605b1b1629562badcce631ad156c700735e681a7aa4f04"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4c18c9f49d4d50a3f48780a0299f7d52893edb5aacfa2e6603b55e5ad332fe55"
    sha256 cellar: :any, arm64_sequoia: "c302f00d3c6dda3167847a3ceecdc079022dccf317f38dd8a3c6094a43c43924"
    sha256 cellar: :any, arm64_sonoma:  "02fef6e450c52e01ae7fde6b0863533d01a839d96d77894fd2c9fa7b0db697ff"
    sha256 cellar: :any, sonoma:        "c6792bbf3910e1ba59e62728c74ed408a0bdb65026d1101ffefeafc4940f5b30"
    sha256 cellar: :any, arm64_linux:   "646d61f06c5763ea82cd17312f9b5f0741372a2c464caa26da74d8ee11e25cfc"
    sha256 cellar: :any, x86_64_linux:  "1a9f5267e6442f5a11cb33c6c6f3d6a4a978414ab6a46545f272c476f33c23f6"
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
