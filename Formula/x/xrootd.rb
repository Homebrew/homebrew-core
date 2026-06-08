class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.0.3/xrootd-6.0.3.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v6.0.3/xrootd-6.0.3.tar.gz"
  sha256 "4b02d60bdfd67177f55df2252f2463d5304fc22ae1fc33223d36f2a836d0f44e"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2d53116999d4cb901eb6486d6f5d252bd93d8945a73eefc73793288dfc10568c"
    sha256 cellar: :any, arm64_sequoia: "c76219ff60f337829ccc5aac5ff9753603609f502ed6f5b6933a121148dee1b5"
    sha256 cellar: :any, arm64_sonoma:  "7f4a6600744e60960cb00ffcc4c91c776ce182d8de30fb1282f1bfdea26fc433"
    sha256 cellar: :any, sonoma:        "b14e76833b00fa43b95fe3bf23842b7da0b06f3d4c891bb76bcea650b4003743"
    sha256 cellar: :any, arm64_linux:   "74ba7bf6c92c7a3ebf4f112813772808a104ed9850ce6002409296d95f5a46a6"
    sha256 cellar: :any, x86_64_linux:  "74385d9450ede5025ea05ad03abe00b8ce63424d944c4c70f9ff82f0af633b0b"
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
