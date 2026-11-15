class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "f564011d38b2888d583d510b08e69ffa15aa117155db1b9b49ef1dfe1fa25111"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  compatibility_version 1
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3e63a31c768cc93f7743ee4ff460c459523fe33cd5282d4b13a59a8fec205498"
    sha256 cellar: :any, arm64_tahoe:       "8486e0373e5c6cb0d3e6363ed03628c92949eb2ae628e427e7b0344600d79156"
    sha256 cellar: :any, arm64_sequoia:     "19202e7aa4183f5fec9335ed196fd804e36c9ac3323040752df86aaec74f8724"
    sha256 cellar: :any, arm64_linux:       "3e5c802a448f77106977c4b8b351feaa7841ea5a6312778541f6edacc50f6d06"
    sha256 cellar: :any, x86_64_linux:      "dec70c02054fe975edbb51778338fd632edba7061d97be3527101bc84ddf3aa1"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
