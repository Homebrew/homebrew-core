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
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "5e151cc2c0ceca8de05d5f4f7f1bf98d5cabf917db585fea82d76fde3cb9dfe1"
    sha256 cellar: :any, arm64_tahoe:       "7702bdf65943a7b8034ec68f5b7d6b5931b924d19af568e296fc19d4f1ac7871"
    sha256 cellar: :any, arm64_sequoia:     "2af1845b1c55625951c23e50faa7b403f2331cb25a0fee4a15aaf21be6104301"
    sha256 cellar: :any, arm64_linux:       "6ff57955e5789fba8c9dbb84e96204360c27a7455b2c97303ab74f4557cb6f52"
    sha256 cellar: :any, x86_64_linux:      "3b7328a417a34d0730f0e5ffa4eebb0f4c78d839661ef3e11042048319bc93b0"
  end

  depends_on "cmake" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "worktrunk", because: "both install `wt` binaries"

  def install
    # CRC32 hardware detection: https://github.com/wiredtiger/wiredtiger/tree/develop/src/checksum
    ENV.runtime_cpu_detection

    args = %W[
      -DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND
      -DHAVE_BUILTIN_EXTENSION_SNAPPY=1
      -DHAVE_BUILTIN_EXTENSION_ZLIB=1
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_PYTHON=OFF
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
