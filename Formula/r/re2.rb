class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2024-03-01.tar.gz"
  version "20240301"
  sha256 "7b2b3aa8241eac25f674e5b5b2e23d4ac4f0a8891418a2661869f736f03f57f4"
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

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "46278237882d1a8fdd48afeb10f94a0cf42ab8d326284f399a433b85ac27eb32"
    sha256 cellar: :any,                 arm64_ventura:  "7585b34981dfba275e500537dc772d6adf100d809d920cc6a83b7d4c5da61db7"
    sha256 cellar: :any,                 arm64_monterey: "68ae4068df93988d1fc3178011d36a05bd87be4f3b738826dcecf75cf3b3fdcd"
    sha256 cellar: :any,                 sonoma:         "8c07eedf0866beee552172f13fe28e50d69be3652edd6095ef46486404e700e8"
    sha256 cellar: :any,                 ventura:        "1c6a5866d90786ecbf2204b3873e3f486f3ea1ad178270f35743c59b04db2929"
    sha256 cellar: :any,                 monterey:       "72db93f852223dacc9eeac34c45f2adee83bd3d92facbfdc1f91dafc0a968386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b517ef3943ec7a5d72654eda4f0bd1fc9d3eed20b8bd32e58aac5c66f187caa6"
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
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
