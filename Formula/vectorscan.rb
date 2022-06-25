class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.7.tar.gz"
  sha256 "cd70c2a7bf632b5374083a450019703605520c10c5614a4c12011c99ab8435dd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "abe4b344d8deccfef0b799220de4f167f9f4bf7036cab75a5046c709fffc36a1"
    sha256 cellar: :any, arm64_big_sur:  "dd42e4b9620e17d37f250beb78be6cdc8547b78a38d02bcf838fd5f986f8fb04"
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
