class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2025-07-17.tar.gz"
  version "20250717"
  sha256 "41bea2a95289d112e7c2ccceeb60ee03d54269e7fe53e3a82bab40babdfa51ef"
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
    sha256 cellar: :any,                 arm64_sequoia: "e701f51e6e1252cfcd718b724aadaa4cfa91b210593ca7bde82be2523a30d42e"
    sha256 cellar: :any,                 arm64_sonoma:  "f0c7660c95d3f7cda4cf15e9c96fc82e97806ec6a8d6de55e3c18b82298adbe6"
    sha256 cellar: :any,                 arm64_ventura: "3de3a5a456cc0f6c83926bd8c37d60fef324a19d4909e154dc06cec8f96cdc8b"
    sha256 cellar: :any,                 sonoma:        "82baa762ff815738e4095e298f1b8ed0276b2d89bf02089a65d6201d2b6228a2"
    sha256 cellar: :any,                 ventura:       "2e8ddd6de851c388500b5e2f88c22c92ba761873bfd4e175e70c56056f02fa92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5278cd7e970bbd2f11792a1ae306bafae79179b8d43af81a6c828287f0786019"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3469e606398eb16108b8b1080534258eadaade49f254ac2a723a4b0b89f9d50"
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
