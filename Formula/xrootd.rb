class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v5.5.3/xrootd-5.5.3.tar.gz"
  sha256 "703829c2460204bd3c7ba8eaa23911c3c9a310f6d436211ba0af487ef7f6a980"
  license "LGPL-3.0-or-later"
  head "https://github.com/xrootd/xrootd.git", branch: "master"

  livecheck do
    url "https://xrootd.slac.stanford.edu/dload.html"
    regex(/href=.*?xrootd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bb2343770848bbd54961a62ef494a5238c0785ef36e69ab90202c918f930412c"
    sha256 cellar: :any,                 arm64_monterey: "87053bf492794e61fe1d18b6057648390323d734b55af8d5f8f5629722b59119"
    sha256 cellar: :any,                 arm64_big_sur:  "266ebe011cacbba922bdb56ec30c3d3e98b22c5acfd24a1f85f272bbaeb5db59"
    sha256 cellar: :any,                 ventura:        "1d916822917c4b4ba1363848af848781c83d9937119f315462fce06f10bf2309"
    sha256 cellar: :any,                 monterey:       "d74ab47104a0c9e5da8fb840f71808ad6f71b4d3b2a5a469cfdcd1b4a0128d59"
    sha256 cellar: :any,                 big_sur:        "2de48ccdaa7870692c703c236226d3da25c8bb5378f97cccd2e0c62c59863882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ebd4e125dcb7c709f9983283270c97dc092db7dc52ec57551df30a9ca3b855"
  end

  depends_on "cmake" => :build
  depends_on "libcython" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "davix"
  depends_on "krb5"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "util-linux"
  end

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
      -DPYTHON_EXECUTABLE=#{which("python3.11")}
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
    system "python3.11", "-c", <<~EOS
      import XRootD
      from XRootD import client
    EOS
  end
end
