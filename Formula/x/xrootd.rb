class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.9.1/xrootd-5.9.1.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.9.1/xrootd-5.9.1.tar.gz"
  sha256 "39946509a50e790ab3fcc77ba0f4c9b66abef221262756aa8bb2494f00a0e321"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e17e1a006be3149a52d22d04b63778ccfb9ac702b391c22d40149ed8e0741610"
    sha256 cellar: :any,                 arm64_sequoia: "2bcaa3a0e5f21d166a513bd4512fdb3428d93020b983e989330bbdfb719196c1"
    sha256 cellar: :any,                 arm64_sonoma:  "20372f4511f80bc1c3e6d9c3b65776756290179f6bd56bd5237a2009b28d98b3"
    sha256 cellar: :any,                 sonoma:        "ba884b887699f4dc3767b1bc976cb602c56a777c8e2702078f44a067f59f970b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bee9840dfb63fdd91812e336caa3c9f71a6dc5c4d556827b2b0ff99f2572257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e3fd497674e6051cb16c26ac7f9b34200d817bdc382a2332b8d4f75975eab77"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" # for libuuid
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
