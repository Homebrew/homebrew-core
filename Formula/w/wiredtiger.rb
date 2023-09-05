class Wiredtiger < Formula
  desc "High performance NoSQL extensible platform for data management"
  homepage "https://source.wiredtiger.com/"
  url "https://github.com/wiredtiger/wiredtiger/archive/refs/tags/11.1.0.tar.gz"
  sha256 "0d988a8256219b614d855a2504d252975240171a633b882f19149c4a2ce0ec3d"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e702595127c63e553e171080dfcece136fba68f49033ae7b31025469033b00f3"
    sha256 cellar: :any,                 arm64_monterey: "a5c31bedec633c773be322ab3b7aa8e74fd947b27158647ad04cf55be79fe07a"
    sha256 cellar: :any,                 arm64_big_sur:  "ffd74182dc67713a3752aa15c0cd7bc2811486b059f3211c43f1d879de6153ff"
    sha256 cellar: :any,                 ventura:        "27db1920028d44d7a4f538212b16864c5992740a21b72f3abf9e3a2f9805b3b5"
    sha256 cellar: :any,                 monterey:       "c0ec5fb4fc6e989cfd2d204297fabc4992f59faa8a08720d348445cb978be0f5"
    sha256 cellar: :any,                 big_sur:        "a4352f0a56362dad537c4c2ed02ac3a080e009b9bcf231b918aed064fdb10258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5718df46cf1737703d1977762a8c4632cb6207ea6a98fa5a7a3450acabf4ffa8"
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "lz4"
  depends_on "snappy"
  depends_on "zstd"

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  # Adds include for std::optional. Remove in version 11.2.0.
  patch do
    url "https://github.com/wiredtiger/wiredtiger/commit/4418f9d2d7cad3829b47566d374ee73b29d699d7.patch?full_index=1"
    sha256 "79bc6c1f027cda7742cdca26b361471126c60e8e66198a8dae4782b2a750c1c3"
  end

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
    system "#{bin}/wt", "create", "table:test"
    system "#{bin}/wt", "drop", "table:test"
  end
end
