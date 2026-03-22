class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.30.0.tar.gz"
  sha256 "c5f94da6de0e0f93925f7ad107bd80fef0615f9b3d111a5bae245f75b1fcc173"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "54fd33027f3080b795d9bb20f7fa69bf04f569812d86fbfe87cf1ccb27c9d59f"
    sha256 cellar: :any,                 arm64_sequoia: "9a296a2fc9496cf3a0a02ca911b8ddd00519889bd959c8e326bf1f30c43b1856"
    sha256 cellar: :any,                 arm64_sonoma:  "d3d0f806307d8f777c41c035d59e2193d809e1915b7e35e27a271c596f6ae87c"
    sha256 cellar: :any,                 sonoma:        "cbcbbdbfadddc8ad1db6f24856e3c7db00da6916da39e5db2860ce2a020ac501"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42d8601468572ca286e43ebf0aba0ef95ed81448731819881ea538c04b25e975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dd9ab013c19d5bfdb2dab16580134e17fe4b80a378fc8e87fa2358cf7fab2d4"
  end

  depends_on "c-blosc2" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build

  depends_on "fmt"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "spdlog"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
