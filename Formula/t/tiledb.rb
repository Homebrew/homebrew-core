class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.30.1.tar.gz"
  sha256 "36381f9eaa2a6defc8990aa1a95d1f0e87971748a50bf6fb705bf032ac7384cf"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "298d95be049b95731ce7e03a00aa8b857992d95e6eb690676048adb2f7377349"
    sha256 cellar: :any, arm64_tahoe:       "f8dd6df4d325b33de752df5be73d5e9bde02f5a3407f6e26783d59b050e6e0a6"
    sha256 cellar: :any, arm64_sequoia:     "ed4416fc2bc014863ba71f74e3b77e6d24abcce30aeda6226eb22ae85e394cac"
    sha256 cellar: :any, arm64_linux:       "05014b6412c3c1f72ad34c4c89b5c884fab57d7a42ee6fb7c989e2a323e784ff"
    sha256 cellar: :any, x86_64_linux:      "3eb0b22f290b82abb3b67cf67925ebf3ed0f7d79907dd8886498d9f4de2749b6"
  end

  depends_on "c-blosc2" => :build
  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build

  depends_on "fmt"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "spdlog"
  depends_on "webp"
  depends_on "zstd"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix version, remove in next release
  patch do
    url "https://github.com/TileDB-Inc/TileDB/commit/9a89804d24ca736a5baadcc0794c7edede2db1ad.patch?full_index=1"
    sha256 "ea540d60699fc58432ccd0702989bcc1782b5d8f18d64c72548672f54197254b"
    type :cherry_pick
    resolves "https://github.com/TileDB-Inc/TileDB/pull/5793"
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
