class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://github.com/xrootd/xrootd/releases/download/v5.6.2/xrootd-5.6.2.tar.gz"
  mirror "https://xrootd.slac.stanford.edu/download/v5.6.2/xrootd-5.6.2.tar.gz"
  sha256 "7d7c262714268b92dbe370a9ae72275cc07f0cdbed400afd9989c366fed04c00"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "8a1af96da395871d89ab52a2ec2869775ac5a636b24d08c709fb903eea4c85eb"
    sha256 cellar: :any,                 arm64_ventura:  "03255af921540bb05bc69d57847c319ab51835fd0440ffa3806f5fbbae9c8def"
    sha256 cellar: :any,                 arm64_monterey: "cf5c06685e1d23849955ca4fd26767b454b8aaf081448105bbd3d8cda6d8b2aa"
    sha256 cellar: :any,                 sonoma:         "9b39b60078b0a11fcf35390fe3af7560c0747ac1d817c0a9dba85d148ff1dcd1"
    sha256 cellar: :any,                 ventura:        "36547262bf54eafd0f2f3016d8881d1704e87ee527b8e0ef5aee2077b0949e22"
    sha256 cellar: :any,                 monterey:       "76e69ac8826a89f16fa0a6d25793407c90992b9ecdfe61b78b5a1efc783a1207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f8b233fdcd32e8ce431a2188754cfe3e253c44918e20148f0e5a043c467a351"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "util-linux" # for libuuid

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFORCE_ENABLED=ON
      -DENABLE_CRYPTO=ON
      -DENABLE_FUSE=OFF
      -DENABLE_HTTP=ON
      -DENABLE_KRB5=ON
      -DENABLE_MACAROONS=OFF
      -DENABLE_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{which("python3.12")}
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

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/xrootd", "-H"
    system "python3.12", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
