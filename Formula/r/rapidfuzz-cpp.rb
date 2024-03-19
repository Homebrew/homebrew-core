class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https://github.com/maxbachmann/rapidfuzz-cpp"
  url "https://github.com/maxbachmann/rapidfuzz-cpp/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "4fddce5c0368e78bd604c6b820e6be248d669754715e39b4a8a281bda4c06de1"
  license "MIT"
  head "https://github.com/maxbachmann/rapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eecb3ad443344ca5bc7ad3b49257f2c86a57e8dfda2e1fbbf5218e01da3f9637"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rapidfuzz/fuzz.hpp>
      #include <string>
      #include <iostream>

      int main()
      {
          std::string a = "aaaa";
          std::string b = "abab";
          std::cout << rapidfuzz::fuzz::ratio(a, b) << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-o", "test"
    assert_equal "50", shell_output("./test").strip
  end
end
