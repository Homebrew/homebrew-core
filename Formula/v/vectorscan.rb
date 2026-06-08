class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.12.tar.gz"
  sha256 "1ac4f3c038ac163973f107ac4423a6b246b181ffd97fdd371696b2517ec9b3ed"
  license "BSD-3-Clause"
  head "https://github.com/VectorCamp/vectorscan.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c6d394819c0355675f1ab7d48cf50cf99d68ae837bce318937c17893a9d2bd3e"
    sha256 cellar: :any,                 arm64_sequoia: "2f6a350d68116e7831fbfe724b02d5aa673f537a08e549cb9c6ca42e71ff0d97"
    sha256 cellar: :any,                 arm64_sonoma:  "b6de07c88d0e1b9d50c59eb42f1a66a2456e418ade7c01b23ec39b122664029b"
    sha256 cellar: :any,                 sonoma:        "9a688ccb297c63cd173638267cac86dc0ce20f3f128d5e4a37270bff8fed567e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "431822dd8fb05a2df316274fa9b8e0bbf11585b00d34a72dd82262507c4929dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08b6394af47d74481f091177957ac9b7ea5fb799975482102223714ddd2c5eba"
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
