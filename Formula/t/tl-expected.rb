class TlExpected < Formula
  desc "C++11/14/17 std::expected with functional-style extensions"
  homepage "https://tl.tartanllama.xyz/en/latest/"
  url "https://github.com/TartanLlama/expected/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f5424f5fc74e79157b9981ba2578a28e0285ac6ec2a8f075e86c41226fe33386"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "281c1fbf5f9bc62c2c7ef1c5d7af6ddb37877a2cb32044e5fd908f8e5420a4c3"
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
    (testpath/"test.cpp").write <<~CPP
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
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    assert_equal <<~EOS, shell_output("./test")
      Result: 2
      Error: Division by zero
    EOS
  end
end
