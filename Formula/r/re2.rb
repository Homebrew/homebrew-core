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
    sha256 cellar: :any,                 arm64_sonoma:   "a483640c4d197e1a8391c3f2fef6e43e26eb65b6d8f1307fb6b5dad3b47f6cd1"
    sha256 cellar: :any,                 arm64_ventura:  "907ecc0af3d53b1dfc3495b1b0ae7e88e58fbba84e2343e2002e02e74f709f71"
    sha256 cellar: :any,                 arm64_monterey: "da782c1c859492d2ba5c71ffbaddee44819dde1f917c7e87009c5f93131483c1"
    sha256 cellar: :any,                 sonoma:         "19967d1f89012d68c06783a0863f7fe6b065d208cbf15dc3c2b02dba2747db98"
    sha256 cellar: :any,                 ventura:        "9015fc1c22e7bd053434a62c8c1aeb089a3262ceb1950d5fa01146a8d5dd2d2c"
    sha256 cellar: :any,                 monterey:       "ca2e9619a036c9583e6a72e58af408c8dccbc18fb5c0f59bab154a2a5ea95efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe82589db5abf0c1d9f45266d00a3d775f6c7f6fb419b303052deaf06f832d16"
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
