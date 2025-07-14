class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.28.0.tar.gz"
  sha256 "de731cd0c8e82fe8cfca084b937dc0df41e451c8eb93071e4cc5aba7bbef854e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9468ff50f991980cd4a1f271157acda6c86180ade8ba9bb6d112c77a9376e791"
    sha256 cellar: :any,                 arm64_sonoma:  "40161d0f697370e27e84f0c0a070936a9e1cf0f648d1b3797f85c36dc16d2525"
    sha256 cellar: :any,                 arm64_ventura: "a845576b2650eaa736ecc376f3870210930a90fc5a539cac056abeaa320ee2ef"
    sha256 cellar: :any,                 sonoma:        "1b49eb9525ee4fd3c1fe79c02ab9b63d8ea2fbf4ea235de722850b82fc9b71a2"
    sha256 cellar: :any,                 ventura:       "38d698425d8a9c8010c5fd6ea2db466979954f6c87ac1d07f2010cd7faa8cf1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeb80c36f1f88dafe9bcd4982ca9089cc55338df63d13cfb2aaa6692a6db9648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367e2dddca418e1fcca9065fc02e3064cf3f6ade0586dde6d022016423895dec"
  end

  depends_on "cmake" => :build

  depends_on "fmt"
  depends_on "libmagic"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "spdlog"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %w[
      -DTILEDB_EXPERIMENTAL_FEATURES=OFF
      -DTILEDB_TESTS=OFF
      -DTILEDB_VERBOSE=ON
      -DTILEDB_WERROR=OFF
      -DTILEDB_DISABLE_AUTO_VCPKG=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <tiledb/tiledb>
      #include <iostream>

      int main() {
        auto [major, minor, patch] = tiledb::version();
        std::cout << major << "." << minor << "." << patch << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-ltiledb", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
