class RapidfuzzCpp < Formula
  desc "Rapid fuzzy string matching in C++ using the Levenshtein Distance"
  homepage "https://github.com/maxbachmann/rapidfuzz-cpp"
  url "https://github.com/maxbachmann/rapidfuzz-cpp/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "26a76c5a881c07638567557c1d73f6601f0d444816de03f297d731b1e019f21b"
  license "MIT"
  head "https://github.com/maxbachmann/rapidfuzz-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f96784f3a96f7b7f99a057ad89b486bceac7043ce55f29476d2fe5028a7259a4"
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
