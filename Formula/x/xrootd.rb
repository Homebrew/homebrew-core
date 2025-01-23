class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.7.2/xrootd-5.7.2.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.7.2/xrootd-5.7.2.tar.gz"
  sha256 "c14c537edc66824ad3ca3c610240f9386c68993cbbcd28473ad3b42c8d14ba67"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fce275e4897892815685e711542016215c0e34a5b80675ead802f4823b5d7d6d"
    sha256 cellar: :any,                 arm64_sonoma:  "c32be48b5b0a6c33cfafacce7c10b1a9e604e22c8471b7f576a4a4fd6107ce1b"
    sha256 cellar: :any,                 arm64_ventura: "7cff6233c1200c4c756cc35076c76ac7a8aadb168b8f8faa376e393c16e74107"
    sha256 cellar: :any,                 sonoma:        "998c4e99e690a7ceb14bfa35a24bc2608c7ec9701fd5f7dc56eb538e4f04d32a"
    sha256 cellar: :any,                 ventura:       "47d4c1a3fdc1ff83d6f0dde2b42b394f0296d8966edc2a7e602cfa5a1ca604ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de6d4ebeccab0ea582861da07fcc41b071b77a918bfc2cf956e92414ff475eb2"
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
