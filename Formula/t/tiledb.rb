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
    sha256 cellar: :any,                 arm64_tahoe:   "9cb9feab02cde5e8ae87d39892c0ba44d3952b85e06f77eabe7485bb18f749cd"
    sha256 cellar: :any,                 arm64_sequoia: "4e0f295fac5255c7a82b939636c5fa248cfdfe4671d55e7a92b386e2527d2f7a"
    sha256 cellar: :any,                 arm64_sonoma:  "67b8e120c9b979462ae503e21318fd44c3fe6380acaca245dc4caba4a249a633"
    sha256 cellar: :any,                 sonoma:        "fbb4cbb718aae628c1c511101f68fa391362f8ebb4855502eacb759e959e4f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beb2c3db549c2b2ee1c014ae97f9a58080c4da0a2b53a7c1f968b79d653f98e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebceb1fdef18e9956deae5774bbc31c04f795cbfb60551ae87829e0ee53a0a3c"
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
