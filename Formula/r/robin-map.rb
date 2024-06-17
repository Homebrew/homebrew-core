class RobinMap < Formula
  desc "C++ implementation of a fast hash map and hash set"
  homepage "https://github.com/Tessil/robin-map"
  url "https://github.com/Tessil/robin-map/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a8424ad3b0affd4c57ed26f0f3d8a29604f0e1f2ef2089f497f614b1c94c7236"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ff6d61f27dfec61e4d040f50458c381a9f31552cbaaea77c11ff88f1442ae40b"
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
