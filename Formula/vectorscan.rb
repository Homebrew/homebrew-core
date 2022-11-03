class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.8.tar.gz"
  sha256 "71fae7ee8d63e1513a6df762cdb5d5f02a9120a2422cf1f31d57747c2b8d36ab"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "478f79fe3f560be59f53b0614dce831ee8ab8851e0d4af1ecec67992456fbaf6"
    sha256 cellar: :any, arm64_monterey: "7ac330c646e8fae05d38781cc74e76ba4f5e56db40d64e5812b86d2b46bc80ae"
    sha256 cellar: :any, arm64_big_sur:  "734f2c58a709fa75fe7f3dfe2abe88ea94b76a27149d07d034f4a779f2197c8a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pcre" => :build
  depends_on "pkg-config" => :build
  depends_on "ragel" => :build
  depends_on arch: :arm64

  def install
    cmake_args = [
      "-DBUILD_STATIC_AND_SHARED=ON",
      "-DPYTHON_EXECUTABLE:FILEPATH=python3",
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    assert_match "hyperscan v#{version}", shell_output("./test")
  end
end
