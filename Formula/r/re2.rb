class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2025-11-05.tar.gz"
  version "20251105"
  sha256 "87f6029d2f6de8aa023654240a03ada90e876ce9a4676e258dd01ea4c26ffd67"
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
    sha256 cellar: :any,                 arm64_tahoe:   "fcfe114f9aee2fa6475c6f33cfdcf28cdcaa3541a52c5920bbbc70aeda67988d"
    sha256 cellar: :any,                 arm64_sequoia: "641887401a7eda45a625cc261028c49d56201bf36fab51ceb659960d598d507c"
    sha256 cellar: :any,                 arm64_sonoma:  "6b011837ff4b94803354ef61e7e01704cf601ac1795bb0373d70a2e844481c50"
    sha256 cellar: :any,                 sonoma:        "23e7c11d34e75bf179f0e538a75a7e96b4e2b821ad34773fe25e3ea13df435ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a78b637b87c698826c3c7afe7e2741496403c0b64a0c9b8679198fc230ae813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ebbd0be34db042d26aaabd84f79b1c94980e1911578879accb9b93b88f016a2"
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
