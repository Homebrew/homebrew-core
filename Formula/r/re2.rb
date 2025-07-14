class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2025-06-26.tar.gz"
  version "20250626"
  sha256 "6090fc23a189e1a04a0e751b4f285922a794a39b6ecc6670b6141af74c82fe08"
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9e6630eec99984adf3adb3e846ca1cb9edb93f2e7da45bb2af33455cfd59a622"
    sha256 cellar: :any,                 arm64_sonoma:  "5dffedca80e8ee43b4dab2a5c1d3a81d0eb1b9bc92f83383b0bf32703621bc0f"
    sha256 cellar: :any,                 arm64_ventura: "98770691d0561564cd1a1d07df2905775d247630708edf0ec9c9672a1483ea64"
    sha256 cellar: :any,                 sonoma:        "51cdd827442293121a0298b8ddf92b1bea41c78f5246362e22f0ed0b0acd7e90"
    sha256 cellar: :any,                 ventura:       "18e1f448e71f2541ad5c7952a029e4ea5714168d6f1c391653f7036ff10ecec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e26604c5085ff54cda0584934ec73a9c583c292e3c60799a12b72ce9091a9cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d887d0f68d78d3feb56355210780dfd9edf2ebc6facb7e1b4b4090b008f1ab"
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
