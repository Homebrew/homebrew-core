class Toml11 < Formula
  desc "TOML for Modern C++"
  homepage "https://github.com/ToruNiina/toml11"
  url "https://github.com/ToruNiina/toml11/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "afeaa9aa0416d4b6b2cd3897ca55d9317084103077b32a852247d8efd4cf6068"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f599c7820bc826902f7466f3bf72bf3b0765bb8d80618a52ed7e22eb1b313ce3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.toml").write <<~EOS
      test_str = "a test string"
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include "toml.hpp"
      #include <iostream>

      int main(int argc, char** argv) {
          const auto data = toml::parse("test.toml");
          const auto test_str = toml::find<std::string>(data, "test_str");
          std::cout << "test_str = " << test_str << std::endl;
          return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_equal "test_str = a test string\n", shell_output("./test")
  end
end
