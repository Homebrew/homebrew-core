class Sophus < Formula
  desc "C++ implementation of Lie Groups using Eigen"
  homepage "https://strasdat.github.io/Sophus/"
  url "https://github.com/strasdat/Sophus/archive/refs/tags/v22.04.1.tar.gz"
  sha256 "635dc536e7768c91e89d537608226b344eef901b51fbc51c9f220c95feaa0b54"
  license "MIT"
  head "https://github.com/strasdat/Sophus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfe43682c321e12b9fa343d74f4e9c4649f6fe362365ed1552a3c4f79c2c1a9c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "fmt"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17 (ceres-solver dependency)

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SOPHUS_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/HelloSO3.cpp"
  end

  test do
    cp pkgshare/"examples/HelloSO3.cpp", testpath
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(HelloSO3)
      find_package(Sophus REQUIRED)
      add_executable(HelloSO3 HelloSO3.cpp)
      target_link_libraries(HelloSO3 Sophus::Sophus)
    EOS

    system "cmake", "-DSophus_DIR=#{share}/Sophus", "."
    system "make"
    assert_match "The rotation matrices are", shell_output("./HelloSO3")
  end
end
