class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.13.tar.gz"
  sha256 "11bfcd2dde32d8a08d1a2eebb09294b12a3fa2be140078f8091b751fa1fabd89"
  license "BSD-3-Clause"
  head "https://github.com/VectorCamp/vectorscan.git", branch: "develop"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "422ca8a342116bd13c7cdac401d327a34b6ffafc93ef2560fa304bc8eb7c5436"
    sha256 cellar: :any, arm64_sequoia: "1459d77a94f01430355978b4a2519434eef87339d082b11f7ae16ff1bd06a00c"
    sha256 cellar: :any, arm64_sonoma:  "0fe9a72aabf7e5b1f887630e91a59b6107178c057acef4ac179cae8b6f35787f"
    sha256 cellar: :any, sonoma:        "a56065eff0d449ad3969617f59521999fed19a8ed706dbc10e2558abacca3a38"
    sha256 cellar: :any, arm64_linux:   "ce523ca550de06bb5cc49ea5aa1226e5e85ace38aa99161c1e7de75ba53ec1f9"
    sha256 cellar: :any, x86_64_linux:  "2f5c9f4baf2f68b0f23da72c6e700dc0898debbba1f3dd1f4a407f480c4c4423"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "ragel" => :build

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
