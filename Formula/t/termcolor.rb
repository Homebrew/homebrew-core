class Termcolor < Formula
  desc "Header-only C++ library for printing colored messages"
  homepage "https://termcolor.readthedocs.io/"
  url "https://github.com/ikalnytskyi/termcolor/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "435994c32557674469404cb1527c283fdcf45746f7df75fd2996bb200d6a759f"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d521f9450ba8bfd71eb601ff8d6ac8e8705c12caf6d10bf8d3f2808463d48091"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <termcolor/termcolor.hpp>
      int main(int /*argc*/, char** /*argv*/)
      {
        std::cout << termcolor::red << "Hello Colorful World";
        std::cout << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_match "Hello Colorful World", shell_output("./test")
  end
end
