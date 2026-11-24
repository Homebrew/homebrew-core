class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://github.com/tristanpenman/valijson/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "49019c677d7290d8ba9c3f3978a76a96f5325dbd4a637de8a5a825a8c92c7ecb"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "9dd18c589d20689a8485d184f4901b7aed00f4702624f17e4ef4872af1e63c62"
    sha256 cellar: :any_skip_relocation, all: "33fe5a38f5fd406b971f2116607f33a705b41377ce314448e142d3a29ca92aa5"
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
