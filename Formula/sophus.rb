class Sophus < Formula
  desc "C++ implementation of Lie Groups using Eigen"
  homepage "https://strasdat.github.io/Sophus/"
  url "https://github.com/strasdat/Sophus/archive/refs/tags/v22.10.tar.gz"
  sha256 "270709b83696da179447cf743357e36a8b9bc8eed5ff4b9d66d33fe691010bad"
  license "MIT"
  revision 1
  head "https://github.com/strasdat/Sophus.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c03acef1a12656ea660610b57869d2df2ac38655fa4e783e2a959e5a65fa008"
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
