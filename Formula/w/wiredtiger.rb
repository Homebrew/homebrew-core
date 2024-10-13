class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "https://source.wiredtiger.com/"
  url "https://github.com/wiredtiger/wiredtiger/archive/refs/tags/11.2.0.tar.gz"
  sha256 "90d1392a9b10dae5bda02d476cb3204331dcf94b3e47ce5e2ab4d4d9b4dd198c"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e7f3509ad95e4eb2a1d81ce017407033273919dd1f6be6c4c84e94562f964afe"
    sha256 cellar: :any,                 arm64_sonoma:   "e197fa1445bd63c676205773ce8e923ddd41710fdf9538f71ba17607630254eb"
    sha256 cellar: :any,                 arm64_ventura:  "85bcc6b06e613f65e191e0a7d62a0f7f270b20c56cbff82f3ece7b7c12f3a2cd"
    sha256 cellar: :any,                 arm64_monterey: "56d763ad1949f872340d073ffee0a856bb93b36c95cf4677efece640d276b59b"
    sha256 cellar: :any,                 sonoma:         "b1a0251185e768cfe22c5a18d16315e2323224b23c06dd8c0a2c5f53ed913d9c"
    sha256 cellar: :any,                 ventura:        "800a9c02a36cf7896635424ea417cb284bdff6374a001d5f25889c01c7184130"
    sha256 cellar: :any,                 monterey:       "0a0e6b9bbecd6fd7dfc3f8b733034c4c9be1da777dbd03cf2a8999bcefb6a715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aaf52d23a2472908928ddb309d4f7aa08143e57a178c698805ca1dd3a00bdc9"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  def install
    args = %W[
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
