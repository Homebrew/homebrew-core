class TlExpected < Formula
  desc "C++11/14/17 std::expected with functional-style extensions"
  homepage "https://tl.tartanllama.xyz/en/latest/"
  url "https://github.com/TartanLlama/expected/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "9a04f4f472fbb5c30bf60402f1ca626c4a76987f867978d0b8a35d7ab3fb8fe7"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0a6195be54cf7f219a4a6f4d9f4fd5955b00f24a786f21d28a48a0d7bd3b98b"
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
