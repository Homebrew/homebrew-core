class RobinMap < Formula
  desc "C++ implementation of a fast hash map and hash set"
  homepage "https://github.com/Tessil/robin-map"
  url "https://github.com/Tessil/robin-map/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "2b54d2c1de2f73bea5c51d5dcbd64813a08caf1bfddcfdeee40ab74e9599e8e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ec3d8a7a6711689502a43c55592977ec6ce631be317ff8e7af3554fdb3b7498"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.12)
      project(robinmap_test)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED True)

      find_package(tsl-robin-map REQUIRED)

      add_executable(robinmap_test main.cpp)

      target_link_libraries(robinmap_test PRIVATE tsl::robin_map)
    EOS
    (testpath/"main.cpp").write <<~EOS
      #include <iostream>
      #include <tsl/robin_map.h>

      int main() {
          tsl::robin_map<int, std::string> map;
          map[1] = "one";
          map[2] = "two";

          for(const auto& pair : map) {
              std::cout << pair.first << ": " << pair.second << std::endl;
          }

          return 0;
      }
    EOS

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "robinmap_test"
    assert_match <<~EOS, shell_output("build/robinmap_test")
      1: one
      2: two
    EOS
  end
end
