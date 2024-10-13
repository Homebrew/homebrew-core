class Sophus < Formula
  desc "C++ implementation of Lie Groups using Eigen"
  homepage "https://github.com/strasdat/Sophus"
  url "https://github.com/strasdat/Sophus/archive/refs/tags/1.24.6.tar.gz"
  sha256 "3f3098bdac2c74d42a921dbfb0e5e4b23601739e35a1c1236c2807c399da960c"
  license "MIT"
  version_scheme 1
  head "https://github.com/strasdat/Sophus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "04f59dd02e4845866fc1513e4292e87432b29310adc0ebbc3c39f5ba4a1588ea"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "fmt"

  fails_with gcc: "5" # C++17 (ceres-solver dependency)

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SOPHUS_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/hello_so3.cpp"
  end

  test do
    cp pkgshare/"examples/hello_so3.cpp", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(HelloSO3)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(Sophus REQUIRED)
      add_executable(HelloSO3 hello_so3.cpp)
      target_link_libraries(HelloSO3 Sophus::Sophus)
    EOS

    system "cmake", "-S", ".", "-B", "build", "-DSophus_DIR=#{share}/Sophus"
    system "cmake", "--build", "build"
    assert_match "The rotation matrices are", shell_output("./build/HelloSO3")
  end
end
