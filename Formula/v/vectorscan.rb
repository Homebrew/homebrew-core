class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.9.tar.gz"
  sha256 "e61c78f26a9d04ccffab0df1159885c4503fc501172402c57f7357a2126ea3c6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "39e6c29a222fefec22d4346eb81841962097e405b6077cf696f8890aab155cf0"
    sha256 cellar: :any, arm64_monterey: "432f5c87edd6de377363fb8348fde42ceefa5c36eea781509bb070a06dccb4ac"
    sha256 cellar: :any, arm64_big_sur:  "5c67d4a31c7253e9bd6b23df0bfa74a31eb527b9410d274fea1da8c4d07afdc0"
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
