class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.org/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.2.0/xrootd-6.2.0.tar.gz"
  sha256 "cf41ba9f56b3baceb4860dfafad50e2f4724062650e125a59b9dbc5ebd6861e0"
  license "LGPL-3.0-or-later"
  revision 1
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "86a0f1c88ec855c5601774ba59d91ace6dd6f96dcf56268f08ea94f5298bce6a"
    sha256 cellar: :any, arm64_tahoe:       "b4dec50e24ef38e40678c106bfcad52456c2589773ff2d1df9d018464d359d6a"
    sha256 cellar: :any, arm64_sequoia:     "b8b2bd32aa8f943e43ae5bab748da1341ccf2702725b9d6ad853a58578124a28"
    sha256 cellar: :any, arm64_linux:       "cc3b7729138f624db935251cea78019b7c0424713df40f06da62f3e8f3e4677e"
    sha256 cellar: :any, x86_64_linux:      "b8649937fed1d1c40130180c1e2776b539b0d917829eb747d3f036ac9d15749b"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.14" => [:build, :test]
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
