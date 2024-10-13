class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://github.com/tristanpenman/valijson/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "0fbd3cd2312b441c6373ee116e9a162c400f9e3cd79f6b32665cdd22fa11ac3f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db56af1ccb1b06996a0ee404f922de2282c29ecd06ff7100724df4091230bd45"
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
