class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://github.com/tristanpenman/valijson/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "35d86e54fc727f1265226434dc996e33000a570f833537a25c8b702b0b824431"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6788da7ea78d3624e0a785c5ffb31cf9e1c518c3f724b18a09e439ef819f9770"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp" => :test

  def install
    system "cmake", " -S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <valijson/schema.hpp>
      #include <valijson/adapters/jsoncpp_adapter.hpp>
      #include <valijson/utils/jsoncpp_utils.hpp>

      int main (void) { std::cout << "Hello world"; }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{Formula["jsoncpp"].opt_lib}", "-ljsoncpp", "-o", "test"
    system "./test"
  end
end
