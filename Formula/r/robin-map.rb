class RobinMap < Formula
  desc "C++ implementation of a fast hash map and hash set"
  homepage "https://github.com/Tessil/robin-map"
  url "https://github.com/Tessil/robin-map/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "7930dbf9634acfc02686d87f615c0f4f33135948130b8922331c16d90a03250c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dee759da00096cb14d4f6d2777261224091f9a811d94c6a56323ffee76b7c066"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.12)
      project(robinmap_test)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED True)

      find_package(tsl-robin-map REQUIRED)

      add_executable(robinmap_test main.cpp)

      target_link_libraries(robinmap_test PRIVATE tsl::robin_map)
    CMAKE
    (testpath/"main.cpp").write <<~CPP
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
    CPP

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "robinmap_test"
    assert_match <<~EOS, shell_output("build/robinmap_test")
      1: one
      2: two
    EOS
  end
end
