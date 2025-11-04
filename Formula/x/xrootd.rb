class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.9.0/xrootd-5.9.0.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.9.0/xrootd-5.9.0.tar.gz"
  sha256 "e08e6fc73aeab08e56f716adafa9476cdfd293e28c14d0af5b1a67c06b1e6831"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fa02ae35434b08ff0818a37de2b0a409c6b08123ba2a6cfb4d9a5a9cdc212ac"
    sha256 cellar: :any,                 arm64_sequoia: "064000b37f6b32d656cbf759b09b22e776bb783856d2892dcee191c2d77ec45e"
    sha256 cellar: :any,                 arm64_sonoma:  "b6d47f90d916f5f7b9c39f3dc0ffa9d8fa0b3cf953a33e466624020d5e1f82de"
    sha256 cellar: :any,                 sonoma:        "1a22ffe56ca4b9f9cbe0bbf20452c9c4fb438031b747c171983b0352bf1a9a63"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc51ac16880f290f6f89c0cae095d85ed63742f143b9922cbde6ecd69a1e0ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c327ea1ba255eac2b6c4c89116d4a9f6bcf3ca462afde41bb967d4b776d02b84"
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
