class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https://github.com/rapidfuzz/rapidfuzz-cpp"
  url "https://github.com/rapidfuzz/rapidfuzz-cpp/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "8d24762d28449aff43035067fe11d94c4c69430b202f44738e9cf8ed51aed38f"
  license "MIT"
  head "https://github.com/rapidfuzz/rapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db2a1f0b02cecbb137fdd5356b2e4cfcc70c6d1dd83e7295e08cfb0511698838"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <rapidfuzz/fuzz.hpp>
      #include <string>
      #include <iostream>

      int main()
      {
          std::string a = "aaaa";
          std::string b = "abab";
          std::cout << rapidfuzz::fuzz::ratio(a, b) << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-o", "test"
    assert_equal "50", shell_output("./test").strip
  end
end
