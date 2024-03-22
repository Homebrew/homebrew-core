class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.11.tar.gz"
  sha256 "905f76ad1fa9e4ae0eb28232cac98afdb96c479666202c5a4c27871fb30a2711"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f9f675e8abdcc7118df42cec8ab5235e50ae24632de7c28ca4156c6fc031b68a"
    sha256 cellar: :any, arm64_ventura:  "389a64eeb361e53204fafaf212e6b408adfab6d02cdf27578a0f11d373ec767a"
    sha256 cellar: :any, arm64_monterey: "d57e73bc3cefeba51e1e93b7a518b5e436efb56e1c7d93ae79e38b1e2200cadb"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pcre" => :build
  depends_on "pkg-config" => :build
  depends_on "ragel" => :build
  depends_on arch: :arm64

  def install
    cmake_args = [
      "-DBUILD_STATIC_LIBS=ON",
      "-DBUILD_SHARED_LIBS=ON",
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
    assert_match version.to_s, shell_output("./test")
  end
end
