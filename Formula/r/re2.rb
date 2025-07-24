class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2025-07-22.tar.gz"
  version "20250722"
  sha256 "f54c29f1c3e13e12693e3d6d1230554df3ab3a1066b2e1f28c5330bfbf6db1e3"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/google/re2.git", branch: "main"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYYMMDD format used in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^(\d{2,4}-\d{2}-\d{2})$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/\D/, "") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d232fba5de598fd8df7fa65d97e1395b99cd9b262b86e3d9f1064f31c6c7103c"
    sha256 cellar: :any,                 arm64_sonoma:  "35cdcfab7117029f9cb36a1afc41cf9818df13be449b83efc4907e816b3333e0"
    sha256 cellar: :any,                 arm64_ventura: "5dec444fb162130f450437755ecd8902a8a0ddfb6325812912755a73333ded1c"
    sha256 cellar: :any,                 sonoma:        "002d96eabae59a621b2a5396b1125aa73945a12f95a7012fbe47bfa366e69e2e"
    sha256 cellar: :any,                 ventura:       "802eb1727c966e23d58d5b570c95931fdf19568371ae52c1bc9742fba4cd8743"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5e35e5da548accf1ed61b4cf874a337dd879db2b02cb1b54397aba3290c3d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d743de5b62c2bf30431d3742970b10ecc4d0a7e952979337d51a8cb6907668f5"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  def install
    # Build and install static library
    system "cmake", "-S", ".", "-B", "build-static",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-static"
    system "cmake", "--install", "build-static"

    # Build and install shared library
    system "cmake", "-S", ".", "-B", "build-shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
