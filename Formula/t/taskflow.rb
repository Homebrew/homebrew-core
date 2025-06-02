class Taskflow < Formula
  desc "General-purpose Task-parallel Programming System using Modern C++"
  homepage "https://github.com/taskflow/taskflow"
  url "https://github.com/taskflow/taskflow/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "fe86765da417f6ceaa2d232ffac70c9afaeb3dc0816337d39a7c93e39c2dee0b"
  license "MIT"
  head "https://github.com/taskflow/taskflow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "19f3e408df4d63fc9360f3a8606b266c64788765291fd5ee92cba91c6d6f4c29"
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
