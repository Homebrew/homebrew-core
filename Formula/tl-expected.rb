class TlExpected < Formula
  desc "C++11/14/17 std::expected with functional-style extensions"
  homepage "https://github.com/TartanLlama/expected"
  url "https://github.com/TartanLlama/expected/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1db357f46dd2b24447156aaf970c4c40a793ef12a8a9c2ad9e096d9801368df6"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c01e63bdebf1017373763e4718078c29fd1965f42cf218636c131a8e139c9d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "263bd21c6da433b8d83e0c090e215cfec4640063be417d59a75ff3a03c908653"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e2286200cda55b599fd2bdcce58657329d610a0b801ad0d634039046a30eb0c"
    sha256 cellar: :any_skip_relocation, ventura:        "82f0c13b7b30ed4a621a8dd5b85b1e39575dd709e0cf7c5169834db345542068"
    sha256 cellar: :any_skip_relocation, monterey:       "440a309ec398ea92922ef2a55895b7fab12f116c929d1e4db4bbc599ff2937ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ee7019c455d5f21628bcd40478392c744134145ef0806626e0a057fc0871d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d58f003ff4417e8ac424b63a3f913d24252b6feabd31ed6b0443bc53ac0a0b7"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DEXPECTED_ENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <tl/expected.hpp>

      tl::expected<int, std::string> divide(int a, int b) {
        if (b == 0) {
          return tl::make_unexpected("Division by zero");
        }
        return a / b;
      }

      int main() {
        auto result = divide(10, 5);
        if (result) {
          std::cout << "Result: " << *result << std::endl;
        } else {
          std::cout << "Error: " << result.error() << std::endl;
        }

        result = divide(2, 0);
        if (result) {
          std::cout << "Result: " << *result << std::endl;
        } else {
          std::cout << "Error: " << result.error() << std::endl;
        }
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    assert_equal <<~EOS, shell_output("./test")
      Result: 2
      Error: Division by zero
    EOS
  end
end
