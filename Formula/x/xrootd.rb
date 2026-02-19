class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.9.1/xrootd-5.9.1.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.9.1/xrootd-5.9.1.tar.gz"
  sha256 "39946509a50e790ab3fcc77ba0f4c9b66abef221262756aa8bb2494f00a0e321"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1278b69fc8fa1e6fa1dc37f09315147671cc28b352b261052fb28b3788747135"
    sha256 cellar: :any,                 arm64_sequoia: "645d195b2add0484efd35889218b7d697b60541d5229dd154cf4979ed6bdf98d"
    sha256 cellar: :any,                 arm64_sonoma:  "223703167d111befddccda5ddd9f6e4acba8d8165a7693c0f4f42bb97a80d068"
    sha256 cellar: :any,                 sonoma:        "0b011704d071049320e8915002d889f72c348ffe22017565dc4f1a3698e1b751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c131286fd8a2b9f33d120b72fd83439e97668b02322433d63d3d496f4df27d38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f3cfa19a96faa8b60fb0300f01b171cae453e8f073327e545918d65de0f68f"
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
