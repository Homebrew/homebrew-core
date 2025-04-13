class Taskflow < Formula
  desc "General-purpose Task-parallel Programming System using Modern C++"
  homepage "https://github.com/taskflow/taskflow"
  url "https://github.com/taskflow/taskflow/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "d872a19843d12d437eba9b8664835b7537b92fe01fdb33ed92ca052d2483be2d"
  license "MIT"
  head "https://github.com/taskflow/taskflow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71f0e0bea86e6e5da59e055c6c8d339d8941889bf753c82b480e3ee5a3d59078"
  end

  depends_on "cmake" => :build
  depends_on "make" => :build

  def install
    args = %w[
      -DTF_BUILD_EXAMPLES=OFF
      -DTF_BUILD_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <taskflow/taskflow.hpp>
      int main() {
        tf::Executor executor;
        tf::Taskflow taskflow;
        executor.run(taskflow).wait();
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-pthread", "-o", "test"
    system "./test"
  end
end
