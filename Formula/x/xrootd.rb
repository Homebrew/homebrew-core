class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.7.3/xrootd-5.7.3.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.7.3/xrootd-5.7.3.tar.gz"
  sha256 "3a90fda99a53cb6005ebecf7d6125ce382cedb0a27fb453e44a2c13bade0a90f"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8718ad437a0bab84ad1ce836ae0cb51c1a6a453d57de165cf726e0b944eef91"
    sha256 cellar: :any,                 arm64_sonoma:  "139d7da8aed265b6bb8725c42592053a03571cea7c41c9c461a1702230e5ba6a"
    sha256 cellar: :any,                 arm64_ventura: "2350884b3be92271750eb48554eb852f2c3b90b6270fbfd85f039802949bf41c"
    sha256 cellar: :any,                 sonoma:        "d619829552fadfb55aa967e449a57b050768c494e9ece2bcd28363171b283337"
    sha256 cellar: :any,                 ventura:       "57dc4fd0887221c8dc9b3ac0406122061dec4cd65e06009f7a4ce1aac30f97db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d60a74372fd55b5883ed4a3e9824ee349a448716a4152b8b1f66d64ca4a36d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
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
    "python3.13"
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
