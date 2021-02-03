class Termcolor < Formula
  desc "Header-only C++ library for printing colored messages"
  homepage "https://termcolor.readthedocs.io/"
  url "https://github.com/ikalnytskyi/termcolor/archive/v1.0.1.tar.gz"
  sha256 "612f9ff785c74dcbe081bb82e8c915858572cf97dcf396ea7bd6a7d21cf6026a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5db4ac397b8826be095a0fcd81d01460ddbb1340fb401f1958df5deaa46c4779"
    sha256 cellar: :any_skip_relocation, big_sur:       "def1f0c727fa7494adaaae105c6567ff1a01cf86a06713ba38272a2c99a2542c"
    sha256 cellar: :any_skip_relocation, catalina:      "bf8dbd74a3f8661b2dcc5968698dc6d0797d32ad4022744fca1c3c2ac1e7b863"
    sha256 cellar: :any_skip_relocation, mojave:        "bf8dbd74a3f8661b2dcc5968698dc6d0797d32ad4022744fca1c3c2ac1e7b863"
    sha256 cellar: :any_skip_relocation, high_sierra:   "bf8dbd74a3f8661b2dcc5968698dc6d0797d32ad4022744fca1c3c2ac1e7b863"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <termcolor/termcolor.hpp>
      int main(int /*argc*/, char** /*argv*/)
      {
        std::cout << termcolor::red << "Hello Colorful World";
        std::cout << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_match /Hello Colorful World/, shell_output("./test")
  end
end
