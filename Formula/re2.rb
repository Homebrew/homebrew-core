class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-08-01.tar.gz"
  version "20200801"
  sha256 "6f4c8514249cd65b9e85d3e6f4c35595809a63ad71c5d93083e4d1dcdf9e0cd6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "6ea685673f2cccce319d1c03da2fdc65796174f32d4c6acaa10774f48f52e6de" => :catalina
    sha256 "b565f33e82a0017a9c7933ce816f201087471920f8a2762e70346b41165ea02a" => :mojave
    sha256 "c2be399e6c6776cdc9e579a1c941756145059ace6f98d3adfd836e08cc4836d8" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    # Run this for pkg-config files
    system "make", "common-install", "prefix=#{prefix}"

    # Run this for the rest of the install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
