class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2024-07-02.tar.gz"
  version "20240702"
  sha256 "eb2df807c781601c14a260a507a5bb4509be1ee626024cb45acbd57cb9d4032b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "e6ca8ebfd1161fd8d32742a6e3a56a911a91456ca186bc27c34c55ac4c79c93f"
    sha256 cellar: :any,                 arm64_ventura:  "38d317ad68fe97305cb75cc90f21cadd69845468d8fc14d6d66638694e7f6ec5"
    sha256 cellar: :any,                 arm64_monterey: "b3e4e43658b85c45e762840fcdbc09e5db524a9cd05a50c40078e31c4a6d6bb4"
    sha256 cellar: :any,                 sonoma:         "a168551f0220a946194cb06a53913e36032a2e4854f5922fc04ee68a4c1a2bad"
    sha256 cellar: :any,                 ventura:        "fa92725409c547665805b4a7c8104ac20364efddf0943d03168876b860f7d644"
    sha256 cellar: :any,                 monterey:       "c979f52308ee2b6a0a8d2f78f04ac6063077123b2b38001e8892f6abd412a540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b53e88cd3b509e7026039fa28bfc5874e6cc321e08e1902c99dcf6c0683165d"
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
