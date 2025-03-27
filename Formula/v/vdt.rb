# TODO: SSE BUG
class Vdt < Formula
  desc "C++ math library of fast approximate and vectorisable trascendental functions"
  homepage "https://github.com/dpiparo/vdt"
  url "https://github.com/dpiparo/vdt/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "8b1664b45ec82042152f89d171dd962aea9bb35ac53c8eebb35df1cb9c34e498"
  license "LGPL-3.0-or-later"
  head "https://github.com/dpiparo/vdt.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "builddir", *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <vdt/sin.h>
      #include <iostream>
      using namespace std;
      int main() {
        cout << vdt::fast_sin(0.0) << endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test", "-L#{lib}", "-lvdt"
    assert_equal "0", shell_output("./test").chomp
  end
end
