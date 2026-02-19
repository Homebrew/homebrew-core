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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "dfd76ff5a1f4613d737c82c0ebb8bcbf5cb79faf7a11a2b103c689bccfbed8f8"
    sha256 cellar: :any,                 arm64_sequoia: "a7462c10690b4b271a507ebe77a9401f6407fd7730d6cffc3dd91f46cecc7f02"
    sha256 cellar: :any,                 arm64_sonoma:  "69d074c898cc7496956c98b3bfe5e65e69ffbd164cb8797f33c004de39e15b2d"
    sha256 cellar: :any,                 sonoma:        "98b5ac96a1369d4e5f87e1538fc4c1d1888ce15949aa901e336561297796fa43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba8058cc496593f04586db264681fa2698427402b7b44de3cccc99402596f2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440d19c8f513fc401876a626f5cbba6ba4750ef959c44bf3106481ec50277098"
  end

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
