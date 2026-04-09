class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.9.2/xrootd-5.9.2.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.9.2/xrootd-5.9.2.tar.gz"
  sha256 "e29edb755d5f728eff0c74f7bd8cec35c954239ea747975eebd9c1e2bd61edb5"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54c270c27a06eb34e533a58fdd92dbce30f882834dfd604f88011af913510a8e"
    sha256 cellar: :any,                 arm64_sequoia: "d60afcccd8cff42bd92345db99b05849c40e2da195f12dcbe9ce8519d4c13892"
    sha256 cellar: :any,                 arm64_sonoma:  "6160b51fa912b92e6b845d9924255d1e7fe402724d12ecfee18586c2dd463d93"
    sha256 cellar: :any,                 sonoma:        "62153bb3efc63986ec9f02bbf8daac6439efbc55a5436117b2093194749f8c78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de2e41a598d713122b99d5742c6626116ab14740788b580d3cbb17903304a6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ada6f623a241ee2a8be42e894d6ad5987718a77b3fad167a31d25d29e558c00"
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
