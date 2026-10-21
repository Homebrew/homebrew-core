class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.org/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.2.0/xrootd-6.2.0.tar.gz"
  sha256 "cf41ba9f56b3baceb4860dfafad50e2f4724062650e125a59b9dbc5ebd6861e0"
  license "LGPL-3.0-or-later"
  revision 2
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b80ef96e113ac0f161b0f88b3b9421016654a49dc8aab0b2b0398819b0e25645"
    sha256 cellar: :any, arm64_tahoe:       "cc2e29f7e52fdc0b001d24af62425401915fa34c99a65c6a37d3829ddae5121a"
    sha256 cellar: :any, arm64_sequoia:     "b6523bd9d607f4f375ab16af08301a05ead38f0c4faa79e85ce497b97d63427b"
    sha256 cellar: :any, arm64_linux:       "1875cf3765636eee4d5b9c8a7f68493c17c9f2da17949145ec1aa647440f2bd7"
    sha256 cellar: :any, x86_64_linux:      "89ce60849d20cd76093c3ca64ec8e91cc263b4368467e9808490aca55ddfb73d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "libzip"
  depends_on "openssl@4"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
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
      -DPython_EXECUTABLE=#{python3}
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
