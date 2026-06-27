class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.org/"
  url "https://github.com/xrootd/xrootd/releases/download/v6.1.0/xrootd-6.1.0.tar.gz"
  sha256 "f50a835def0c5b2ff65d377ebbeed42cf1efe243ecd599218ff441a67854859e"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "665aa524c3901ce8f142ceb44d3e23cf137d9d5f71d42e4976506764d680c679"
    sha256 cellar: :any, arm64_sequoia: "64f9e0034fc4eda46e9f2438e8cd5536f9018639e8abef951dc949e3baa60df2"
    sha256 cellar: :any, arm64_sonoma:  "6e98f8766ef8cc52589aa11bf17a7c444362cca41c25dcec31d72fad50350c74"
    sha256 cellar: :any, sonoma:        "0fc143346b699b549f301c547a30de6f7e162327a8b440db781421acb1424da0"
    sha256 cellar: :any, arm64_linux:   "83e176d7678dd5c56a225135a63fd0a4f17d7addafc01b3ecea9862cd0840064"
    sha256 cellar: :any, x86_64_linux:  "32eac51cf6d6b2609e822fc4bda415cc112a23487c59b5bd19708383d6d6ba26"
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
