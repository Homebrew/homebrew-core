class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.8.4/xrootd-5.8.4.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.8.4/xrootd-5.8.4.tar.gz"
  sha256 "d8716bf764a7e8103aab83fbf4906ea2cc157646b1a633d99f91edbf204ff632"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7dfcbbd225e831a72af32ddf2f6765f9f347ab5d24d8bf64dc2be29c2f56ac4f"
    sha256 cellar: :any,                 arm64_sonoma:  "edb1a3c719ca45f6e38d77361f2a6d8057539fde60d72206df6f7f4de60a89b4"
    sha256 cellar: :any,                 arm64_ventura: "683dae2860b90c1bb54f2105785d41b2a6627f1386aaca42ab16e9a316983e4f"
    sha256 cellar: :any,                 sonoma:        "77de9f225153cb2cabf81ddbbb8e24c683bea6100f2d86c69daa914d8542b13d"
    sha256 cellar: :any,                 ventura:       "c8a7040ea9d59933fea1d6c842205aef51825a89ad96d3eb7c4d83a61a490bbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dcaf3a69fb358e9f08b6b995aa45f680522d61d84e43403581267d297e5b23b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fb3d934fff0e2e4b3ec1db4d0fcdded57aeb96176a5d214d23d319270a7eac7"
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
