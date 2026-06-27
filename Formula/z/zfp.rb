class Zfp < Formula
  desc "Compressed numerical arrays that support high-speed random access"
  homepage "https://zfp.llnl.gov"
  url "https://github.com/llnl/zfp/archive/refs/tags/1.0.1.tar.gz"
  sha256 "4984db6a55bc919831966dd17ba5e47ca7ac58668f4fd278ebd98cd2200da66f"
  license "BSD-3-Clause"
  head "https://github.com/llnl/zfp.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dbdf86f2faa53f3b2ab4f9c66a298b1e24208f0a1a8231da5ee516f385d65d1d"
    sha256 cellar: :any,                 arm64_sequoia: "264d7d638461625ada9fb5d1a78d0d0b61a398020025839b834caa27b6b0b00e"
    sha256 cellar: :any,                 arm64_sonoma:  "d38ad5e6a7997eb5141c1b90c09ad7e819b1732488549ca76c9da95e50fc788f"
    sha256 cellar: :any,                 sonoma:        "6ad6c3b458e26c614324526bd647929e17dd270308d7463ff376a6d6d147606c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d50a325063801b02fd5e5c7f07b390b77dc214265d9b7bc6c05375211be92710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77905d574f33142c25ecbe83d87817224bb62ff43cf9f1b6e7346af2688cf6ba"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <vector>
      #include <zfp/array2.hpp>

      int main()
      {
        const size_t nx = 12;
        const size_t ny = 8;
        const double bits_per_value = 4.0;

        zfp::array2<double> arr(nx, ny, bits_per_value);

        for (size_t y = 0; y < ny; y++) {
          for (size_t x = 0; x < nx; x++) {
            arr(x, y) = x + nx * y;
          }
        }

        arr.flush_cache();
        std::cout << "zfp bytes = " << arr.size_bytes(ZFP_DATA_PAYLOAD) << std::endl;

        return 0;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test_zfp)

      set(CMAKE_CXX_STANDARD 11)

      find_package(zfp REQUIRED)

      add_executable(test test.cpp)
      target_link_libraries(test PUBLIC zfp)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
