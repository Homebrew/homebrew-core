class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.28.1.tar.gz"
  sha256 "f011240a2ab7863b037a2e5531a0cba537dd65f603fa2508878541514a472e90"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab4f7f8d37bd85fd72974f6786a90fdafc145152c110d50748b95038c3745334"
    sha256 cellar: :any,                 arm64_sequoia: "58a3d297198f9475bf928ff9dacdb15e9eaf39abbeea80495a76011124bbb2ce"
    sha256 cellar: :any,                 arm64_sonoma:  "92d58bb7e8c9bf76e2ef43a13bd4d1444280e2a4ef8a70fd798773a5f5f78387"
    sha256 cellar: :any,                 arm64_ventura: "d88069d7b5752c6a20559dfb2b11a3e75a396d77c0328dc5a9815ce1ca7b9e3a"
    sha256 cellar: :any,                 sonoma:        "0572d46029ca4f5970f327a8b8f0c19ce2c303a072d7e88fddd1f172b0d95c55"
    sha256 cellar: :any,                 ventura:       "a0eab1d6dcc106ca683022f1a66e0921ee6138a57d8d245e55e3c48b5c79c0ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ee6cebf5c288281f53636027ed049ea9cf1860ed4cce4136885e2edb27f5ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc942a87a4e62ff078cf9ffde7e270ad5552fe67d145e9441f9e0654d7103f5"
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
