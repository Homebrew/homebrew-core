class Tiledb < Formula
  desc "Universal storage engine"
  homepage "https://tiledb.com/"
  url "https://github.com/TileDB-Inc/TileDB/archive/refs/tags/2.29.0.tar.gz"
  sha256 "5340e820323cdd48eac3cbd28ad55c1724f3f0b20dd2b88d196f336cffd92cdf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10a74e5c3058c7e75fab61ddccf610bb87b9f55d08d6450140e3a90b4b8c4ef5"
    sha256 cellar: :any,                 arm64_sequoia: "a195072c143c898e1b70d633d05ea5ecbd3659ca460d726137afd4f891a68caa"
    sha256 cellar: :any,                 arm64_sonoma:  "22768991d99b91ad2acbcd24516e8ea817be0ce568ab82b1e255f58800a76310"
    sha256 cellar: :any,                 sonoma:        "38c236878e7b69c053caaa2d0b2e2dc304743040ec02ae92166f7e8d1634e3b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68bbb4e7f90d7665f3b74a747d5288c8985521450eb937c255df70f28d09be34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15df5ce31c24ab2b0418c150297fe75c509f172eb65b1e6d6d6ac0538385b5be"
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
