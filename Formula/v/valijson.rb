class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://github.com/tristanpenman/valijson/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "6fa0223e18fda67e630f21b54b0d9578496f687f792e0d8b8db4da48e5930d7d"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35da7cbb2ef13300e02b51f1ac618f1155a6383b3fb5e11ebcf8e519c5f55a83"
  end

  depends_on "cmake" => :build

  depends_on "jsoncpp" => :test

  deny_network_access!
  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <valijson/schema.hpp>
      #include <valijson/adapters/jsoncpp_adapter.hpp>
      #include <valijson/utils/jsoncpp_utils.hpp>

      int main (void) { std::cout << "Hello world"; }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{formula_opt_lib("jsoncpp")}", "-ljsoncpp", "-o", "test"
    system "./test"
  end
end
