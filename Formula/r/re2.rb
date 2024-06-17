class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2024-06-01.tar.gz"
  version "20240601"
  sha256 "7326c74cddaa90b12090fcfc915fe7b4655723893c960ee3c2c66e85c5504b6c"
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
    sha256 cellar: :any,                 arm64_sonoma:   "cc945b55baacae4aeb5425a6f0c411eda3fe7b2a9695151eec889c5adef401d8"
    sha256 cellar: :any,                 arm64_ventura:  "e3edb6db9b2b505ab35c04c36f90e67839371916399f9a0da8d55a4ae2f047fc"
    sha256 cellar: :any,                 arm64_monterey: "2ece39a29ccb7a45ad28ea2780a1a5df0656464d0d8b5a83826cf3a44fce6714"
    sha256 cellar: :any,                 sonoma:         "f70ff496de6e869a96f38bfd9f300a6bf30fcd29577ea761b50993361e5c6eb6"
    sha256 cellar: :any,                 ventura:        "c33f02810c56b2ea30660c40d2730872530c677dcff1c2188b77bb19b87334b8"
    sha256 cellar: :any,                 monterey:       "0b834bc40238ed867bc2f2b09e8847eec15efcaba819f40facb87b1c2131c7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f653d07031a99cfd18c1c4faa07b7a1816ce3b22e08e4d363d66df255be684"
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
