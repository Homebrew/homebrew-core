class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.12.tar.gz"
  sha256 "1ac4f3c038ac163973f107ac4423a6b246b181ffd97fdd371696b2517ec9b3ed"
  license "BSD-3-Clause"
  head "https://github.com/VectorCamp/vectorscan.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ccf33c9cfa23e8e02319a6ed2a40d116699c7c943439b44e88e6068f8696f79"
    sha256 cellar: :any,                 arm64_sequoia: "7fedda4e165b82f826e9d5fc14d8be8cd2c55dcd26c08d474271b07c74b2ab9b"
    sha256 cellar: :any,                 arm64_sonoma:  "3bcf577d4c91d01f7519cbb38e00bb3bae03328adf8798cc725576b9aa578f9d"
    sha256 cellar: :any,                 arm64_ventura: "ed29f6c36f2949e388e2c3f721ecf46891ed855d5c58212e06f559e0908c5e52"
    sha256 cellar: :any,                 sonoma:        "b628c16819474af7f2f092daaf2d4a3f0497ad9129925c9100a7cc1112077f9a"
    sha256 cellar: :any,                 ventura:       "d20eebae83e57037cf31393d3e6fcea980bf6e6681d7e42bf03bf1858f4aeb4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6235d9e69a6434f6be35351c33eb667b45e533fe26d8755253368e5a1ae7f512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "764260a875c598d22c3abc692855aa7045fb5350e78add953320055f786f0154"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pcre" => :build # PCRE2 issue: https://github.com/VectorCamp/vectorscan/issues/320
  depends_on "pkgconf" => :build
  depends_on "ragel" => :build

  def install
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
