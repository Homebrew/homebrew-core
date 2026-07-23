class Taskflow < Formula
  desc "General-purpose Task-parallel Programming System using Modern C++"
  homepage "https://taskflow.github.io"
  url "https://github.com/taskflow/taskflow/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "2107f90e315e48a676922010b036357ff2b0c6b9160ce17fa9396e5860b1d715"
  license "MIT"
  head "https://github.com/taskflow/taskflow.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3631e5f8b148b811fb31cbc1c17a514b430757d6002b88d8ac94b7feb3834353"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3631e5f8b148b811fb31cbc1c17a514b430757d6002b88d8ac94b7feb3834353"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3631e5f8b148b811fb31cbc1c17a514b430757d6002b88d8ac94b7feb3834353"
    sha256 cellar: :any_skip_relocation, sonoma:        "3631e5f8b148b811fb31cbc1c17a514b430757d6002b88d8ac94b7feb3834353"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f0096ef03f30a8aa61b82da550af5d355af6c889bad32c910b6b45f46ca7c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f0096ef03f30a8aa61b82da550af5d355af6c889bad32c910b6b45f46ca7c43"
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
