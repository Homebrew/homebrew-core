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
    sha256 cellar: :any, arm64_golden_gate: "160fc196b35cf6194be3af3bf7e85b84138328c76ee084f39c2a55bb9b1d1f57"
    sha256 cellar: :any, arm64_tahoe:       "be521950c639e54e29a85387bae7b5b244406e4d0456ffa67dc025e3a0416901"
    sha256 cellar: :any, arm64_sequoia:     "3e5a890e2294247cd0ef56715bba2813bb57edc17d275da485bc2026f33a343f"
    sha256 cellar: :any, arm64_linux:       "4c3d39ec1d5c1969d359dcf6b137a0760e780275f6781cf46943bc839fbe3d4a"
    sha256 cellar: :any, x86_64_linux:      "91a07d10c80c5ba84c1138ed5eb7162c9c98e9320cf318fabc971ff5378a7695"
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
