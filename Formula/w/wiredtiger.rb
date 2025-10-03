class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "https://source.wiredtiger.com/"
  url "https://github.com/wiredtiger/wiredtiger/archive/refs/tags/11.3.1.tar.gz"
  sha256 "ac0417c10cecc686baff5fdc00a7872003fc007993163bafba387fad903d5091"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63fefdf4715c6dd504e69d3f5ca1ca38d81f4bcb343007eab4f25f0d205f5f6a"
    sha256 cellar: :any,                 arm64_sequoia: "fe94103be40ac4d1f2030cf28f3bd93dda5f65f45196884e18e21dc48825a502"
    sha256 cellar: :any,                 arm64_sonoma:  "6f46b39b9ad85313b1cbcb81e9b86204a15a017b859bbbafac05094a994a5284"
    sha256 cellar: :any,                 arm64_ventura: "0333748feb3a4d7939b945a6e24dda5a73f7a9fcc7497e21b8af17ce6197e666"
    sha256 cellar: :any,                 sonoma:        "2c6472b714776076789ecdab468016f3c4b25ebcd84695ca70a67d463537c4a6"
    sha256 cellar: :any,                 ventura:       "4085e3bbb32627b3dac06760f86dfb6e28a7d580dfa9cbeaab94a3126a4f11da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18d06663d840ca7f85f41444dc1ffce4571bed81429217d3937e6990c22287ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "100e4051caa78dbd63c57f3e0a3be5f0272676e187c191d040068cbaf5c67aa4"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    # CRC32 hardware detection: https://github.com/wiredtiger/wiredtiger/tree/develop/src/checksum
    ENV.runtime_cpu_detection

    args = %W[
      -DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND
      -DHAVE_BUILTIN_EXTENSION_SNAPPY=1
      -DHAVE_BUILTIN_EXTENSION_ZLIB=1
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DCMAKE_C_FLAGS=-Wno-maybe-uninitialized" if OS.linux?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"wt", "create", "table:test"
    system bin/"wt", "drop", "table:test"
  end
end
