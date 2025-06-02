class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.8.2/xrootd-5.8.2.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.8.2/xrootd-5.8.2.tar.gz"
  sha256 "738111dabdf6c06094ae5d4ccac9471617a3d2a7b4c0dbe15c3717153c3a9564"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e54094b1df55be63dd93f862b02b08c48896d3f8de6ff02b8260f161c0a38c30"
    sha256 cellar: :any,                 arm64_sonoma:  "f5415634da71a8168e51d807f096bff10b4ce952760208ce750159c6bb9098ef"
    sha256 cellar: :any,                 arm64_ventura: "83e1067519177995e01ec2a940f62a7159f4ef536185a3b67b31a69206bbcd07"
    sha256 cellar: :any,                 sonoma:        "acbc9d8b3dbf654f4b832adf98f5e92cb108140a4a9512340e37569498411e43"
    sha256 cellar: :any,                 ventura:       "e21dc1d127195ee77dd96299223d4bf17935b9726f3a31360d9372ac71f4d13a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e92d7aa019e95964c7425471f7a0f1605f539f59c489425d456908db2ba7c5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d788622ed26804020885123cbe99c815cf99982b16c2891c4dae7d9d80bc8aa4"
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
