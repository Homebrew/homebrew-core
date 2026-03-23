class Qthreads < Formula
  desc "Lightweight locality-aware user-level threading runtime"
  homepage "https://www.sandia.gov/qthreads/"
  url "https://github.com/sandialabs/qthreads/archive/refs/tags/1.23.tar.gz"
  sha256 "fb5c3efc022231245f7b1894a82eac1fd020c5f90000bb4770e64e2c1ad77913"
  license "BSD-3-Clause"
  head "https://github.com/sandialabs/qthreads.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f455a5b42d23a1151bfcff2b905895f1a0c3e3fff9bd7c6db3f3c7532edb580b"
    sha256 cellar: :any,                 arm64_sequoia: "1e6f3e2eb3912d28d4090a64c205d6fdf25fc8e5f24d5eb9b0f0e4aef711f052"
    sha256 cellar: :any,                 arm64_sonoma:  "ff6c0b330b2df5181cd7df2941577e840e6940891425a7eeec35ff1df7bbfbaf"
    sha256 cellar: :any,                 sonoma:        "8fe16a4de2fb44ea1adaf8dae0786e46ba7199fdb57e4ef5584384bb76dd660e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40ef0b72f54ac93aa7a7f0798d0d1e55ae5df9ce3a2329aa280ad76db0ecb482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a54569cf1e22ecf35bceb1043fca31c97b86651c0782d00f856f1a31dc518c"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "userguide/examples"
    doc.install "userguide"
  end

  test do
    system ENV.cc, pkgshare/"examples/hello_world.c", "-o", "hello", "-I#{include}", "-L#{lib}", "-lqthread"
    assert_equal "Hello, world!", shell_output("./hello").chomp
  end
end
