class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https://toruniina.github.io/toml11/"
  url "https://github.com/ToruNiina/toml11/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "815bfe6792aa11a13a133b86e7f0f45edc5d71eb78f5fb6686c49c7f792b9049"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b7ee42a48906e90cc3f54ef70b943bdc34edec94917f745f2e2dee74d75802e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=11",
                                              *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.toml").write <<~TOML
      test_str = "a test string"
    TOML

    (testpath/"test.cpp").write <<~CPP
      #include "toml.hpp"
      #include <iostream>

      int main(int argc, char** argv) {
          const auto data = toml::parse("test.toml");
          const auto test_str = toml::find<std::string>(data, "test_str");
          std::cout << "test_str = " << test_str << std::endl;
          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "test_str = a test string\n", shell_output("./test")
  end
end
