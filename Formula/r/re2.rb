class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2024-05-01.tar.gz"
  version "20240501"
  sha256 "fef2f366578401eada34f5603679fb2aebe9b409de8d275a482ce5f2cbac2492"
  license "BSD-3-Clause"
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
    sha256 cellar: :any,                 arm64_sonoma:   "fa6efe442f1e12168a59fd5fb81606f1fbb5422e101e67106f8f95eb1642a68a"
    sha256 cellar: :any,                 arm64_ventura:  "e8ceb41cc5d6c4cdc713fdd6d118f94a50c3eadf5f00d9533dfd72c4e603893e"
    sha256 cellar: :any,                 arm64_monterey: "99f4547c309bbabb56cd9bbc20d5a9c6dd6745e5a524b6a645a0661dbb9f19c9"
    sha256 cellar: :any,                 sonoma:         "b378b3a4ae3aca4f7a3bd1ba0250d99194145fd38226af361817116324196fad"
    sha256 cellar: :any,                 ventura:        "1f515790bf4dfd1efeef92a5992b95f4bb05e9b92863bdccf13e719fa506977a"
    sha256 cellar: :any,                 monterey:       "28ca6d456dbc92950101a3930d951a06ac9775d96dacb36775ea29aeb0889b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b6107140fbf9a91a9ddb851bd6d70a3db1851f565a49d5fd9219af839da3e98"
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
