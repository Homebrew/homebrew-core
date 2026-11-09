class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.14.tar.gz"
  sha256 "8a035e5a7e769f3793d50645a17042bcd601a2f9835b32c535eae7b1a9b9f0e0"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/VectorCamp/vectorscan.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be51d7a3b1140b8a673aa6c6da9c9f48e0ad81cb42e056f4f2589b61724c5b87"
    sha256 cellar: :any, arm64_tahoe:       "df6b7e60803aba7c1f10e2f05628a5e4302b85e39954df64a29f184c89493f11"
    sha256 cellar: :any, arm64_sequoia:     "4bf3e1e734efb30d41e0a1ed42eee43538860ef56eb0500cdaf30a0d6bbc1254"
    sha256 cellar: :any, arm64_linux:       "9ff3ff25f30ada840226a47367c41a716271ce86de4167f8f62fe95c03f01f04"
    sha256 cellar: :any, x86_64_linux:      "338effe7bba5a5308f57e3b2f2520220d54097c2632ceb17a31bed796ba93743"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ragel" => :build

  deny_network_access!

  def install
    # Avoid building hscollider which needs EOL `pcre`
    # Issue ref: https://github.com/VectorCamp/vectorscan/issues/320
    rm("tools/hscollider/CMakeLists.txt")

    cmake_args = [
      "-DCCACHE_FOUND=CCACHE_FOUND-NOTFOUND",
      "-DBUILD_STATIC_LIBS=ON",
      "-DBUILD_SHARED_LIBS=ON",
      "-DFAT_RUNTIME=OFF",
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
