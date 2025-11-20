class Sophus < Formula
  desc "C++ implementation of Lie Groups using Eigen"
  homepage "https://github.com/strasdat/Sophus"
  url "https://github.com/strasdat/Sophus/archive/refs/tags/1.24.6.tar.gz"
  sha256 "3f3098bdac2c74d42a921dbfb0e5e4b23601739e35a1c1236c2807c399da960c"
  license "MIT"
  revision 2
  version_scheme 1
  head "https://github.com/strasdat/Sophus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fece7681865de760678d27236420c150d92b2a4ffb0ae376228e7d793ec07d6a"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "ceres-solver"
  depends_on "eigen"
  depends_on "fmt"

  # Apply open PR to support eigen 5.0.0
  # PR ref: https://github.com/strasdat/Sophus/pull/558
  patch do
    url "https://github.com/strasdat/Sophus/commit/fd3fcfa116f078d731d062d1d74f2b31aaf8854f.patch?full_index=1"
    sha256 "0f91d6051c9b66051916a1c52fb223b63575a43ec941f5091a68848195aa2429"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SOPHUS_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/hello_so3.cpp"
  end

  test do
    cp pkgshare/"examples/hello_so3.cpp", testpath
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{Formula["cmake"].version})
      project(HelloSO3)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      find_package(Sophus REQUIRED)
      add_executable(HelloSO3 hello_so3.cpp)
      target_link_libraries(HelloSO3 Sophus::Sophus)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", "-DSophus_DIR=#{share}/Sophus"
    system "cmake", "--build", "build"
    assert_match "The rotation matrices are", shell_output("./build/HelloSO3")
  end
end
