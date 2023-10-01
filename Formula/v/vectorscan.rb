class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  # TODO: update version check for new release
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.10.1.tar.gz"
  sha256 "ed4fb5aafecca155c4ce2f9b2c0ab781dc92fee720f77f4f4d56b651787ae118"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "149dae0569f8e2adb301b7942c56cb0e7ad0c9e1f8ad35592c30be7b1910b101"
    sha256 cellar: :any, arm64_monterey: "809da23231e472b698c49a0e70cf13867ebfd44bacdb552be44c0363442694a8"
    sha256 cellar: :any, arm64_big_sur:  "456709a5ccd7fafce90c8f268d9f23625b9ef60ae358c15e4fbd51a25180b467"
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
    assert_match version.major_minor_patch.to_s, shell_output("./test")
  end
end
