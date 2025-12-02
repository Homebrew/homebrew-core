class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.29.2.tar.gz"
  sha256 "44fd4c6c25938a123edc711f082a1c3e632a9f8365e64fe745bbf1e782d671d4"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "02f86f511b5d85848742a4af105f26a21598d8e0f172b81e0ac936fd6f682f75"
    sha256 cellar: :any,                 arm64_sequoia: "245896cb1dca1f07cf62d6f4432e85acc075aaa901f1861267f84ea018ebf319"
    sha256 cellar: :any,                 arm64_sonoma:  "1222c3681558e5dc5a009dc745df62ac8f7ce8d65f7d72b169f27b1e9503ded9"
    sha256 cellar: :any,                 sonoma:        "7840d3e2c1e9cf82553cb7f9e499da5f8e2fb230ec999592c65a22ca8560e851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb08b1a1bac4d9970eb1641c13e5a72046421932b8ef1391426cc42a5f2c249a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34ab078fe1250242ff17222bef7b2b494f8fd20a52a336c1d14c5b7af7e8563b"
  end

  depends_on "cmake" => :build

  depends_on "fmt"
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
