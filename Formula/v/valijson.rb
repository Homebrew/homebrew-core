class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://github.com/tristanpenman/valijson/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "887b53b1a924f6fe0b35fa3bbc9bbbe5ae8c72097b7f0f7c17b45f4cfa646029"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ec954911f843d9b5090b0b36b59aabb4e20dae934b2a4c9f81b88faf3fccdf4"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp" => :test

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
