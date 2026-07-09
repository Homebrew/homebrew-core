class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://github.com/tristanpenman/valijson/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "90208a2073757d70c89105ecb5920b314f41edcb27689ac609f5b14fd86b7d49"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3aa03b6d12c7a8960033b245cff7310b5895ee5cd7589f03e3ae99cb6a7309cf"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp" => :test

  # Workaround for missing `std::from_chars` in macOS < 26 sdk, remove in next release
  # PR ref: https://github.com/tristanpenman/valijson/pull/241
  patch do
    url "https://github.com/tristanpenman/valijson/commit/940843d4f954330265b2c961a675cee4ff72fadb.patch?full_index=1"
    sha256 "b1498cc4683091eb1a7bb6ae25eac47366027dbc3699f5aa0b16a97a455dfc4b"
  end

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
