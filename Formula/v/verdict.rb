class Verdict < Formula
  desc "Compute quality functions of 2 and 3-dimensional regions"
  homepage "https://github.com/sandialabs/verdict"
  url "https://github.com/sandialabs/verdict/archive/refs/tags/1.4.5.tar.gz"
  sha256 "8c3ba194894a1b10b0700643363d02514cfdf88109a0c2710c0a32e857b2bde0"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/sandialabs/verdict.git", branch: "master"

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DVERDICT_ENABLE_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <verdict.h>
      #include <iostream>

      int main(void)
      {
        double coords[4][3] = { { 0, 0, 0 }, { 1, 0, 0 }, { 0, 1, 0 }, { 0, 0, 1 } };
        std::cout << verdict::tet_inradius(4, coords);
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lverdict"
    assert_equal "0.211325", shell_output("./test")
  end
end
