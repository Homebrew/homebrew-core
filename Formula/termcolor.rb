class Termcolor < Formula
  desc "Header-only C++ library for printing colored messages"
  homepage "https://termcolor.readthedocs.io/"
  url "https://github.com/ikalnytskyi/termcolor/archive/v2.0.0.tar.gz"
  sha256 "4a73a77053822ca1ed6d4a2af416d31028ec992fb0ffa794af95bd6216bb6a20"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6600a6345ddca25f57a8ac394b62edac659399eb1c7eab287c201108ac390461"
    sha256 cellar: :any_skip_relocation, big_sur:       "86b0707099a56545dc78d87c81407b998c900c22d14b23d53ffa35eafa2e01f2"
    sha256 cellar: :any_skip_relocation, catalina:      "41012d8fe7ea77d22b30dc9baeac6aa0472b66c4f40e490b214ae34d20076cb1"
    sha256 cellar: :any_skip_relocation, mojave:        "49ed93a14e7bd15d692c8222d161dc732b3836b829f1dbc4b2e7326d66620674"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52499ef8a399cb540793ce3f0ed8e3c857ea60681942fed858170642017fb4ba"
    sha256 cellar: :any_skip_relocation, all:           "51b0b25be9b4a3cc951c6252dfc94c2dd06787eb1cea9bb100257a5359d2c770"
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
    assert_match "Hello Colorful World", shell_output("./test")
  end
end
