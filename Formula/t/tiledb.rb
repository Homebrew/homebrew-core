class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.29.1.tar.gz"
  sha256 "e507b6edf2a3893038ae92c74b4756561f3c11a03c6c311c7ae76d40f924cc05"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2fb182526778c1ee5dbcb90bfe6b14625a85e7ea7cfc254429b6e3c951e3d010"
    sha256 cellar: :any,                 arm64_sequoia: "797ea84f38bbee14931ef2be3775c9c12ce9ba0520e754045383d53c9accd73a"
    sha256 cellar: :any,                 arm64_sonoma:  "6ef0cfe0ae29310bcc005403269d98e365cbe176412b22f6c7b7475b456d4a05"
    sha256 cellar: :any,                 sonoma:        "bb5bf1f5fea8d6731a8d4a96730ad9dd0953f24919e23b8610b2b3060fee733b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d5569b052311c4710ce3ac5371804323e5301e92b745c61a3fa3977434747e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7abf318311253b7b9f2f9771386d209d04176729995f4daf7bbe3087ef3990cf"
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
