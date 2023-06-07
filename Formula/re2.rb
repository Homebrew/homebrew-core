class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2023-03-01.tar.gz"
  version "20230301"
  sha256 "7a9a4824958586980926a300b4717202485c4b4115ac031822e29aa4ef207e48"
  license "BSD-3-Clause"
  head "https://github.com/google/re2.git", branch: "main"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYYMMDD format used in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^(\d{2,4}-\d{2}-\d{2})$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub(/\D/, "") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1859e5dda089deee38d6800aa0fe06369011c8f6813767d1ce0794f56f9c59c7"
    sha256 cellar: :any,                 arm64_monterey: "b9ba6456398e73df6d5fdc6621c6c8817669bc920c98396f3d330962b3ffe34e"
    sha256 cellar: :any,                 arm64_big_sur:  "7335f87d5d389c982c250978c47810b0e33209c64bbdd47069e2d955fa4903eb"
    sha256 cellar: :any,                 ventura:        "7f161ab81e64a5a1d018ebc8002a8a428056803bb791dd6158a8c3abe7bc7c11"
    sha256 cellar: :any,                 monterey:       "b5b2b4c595694947e56db2a4a22f8dfa9e04301f246516a7d48b37cacdb06206"
    sha256 cellar: :any,                 big_sur:        "5b115fd3a925aabbf9ba972827921e1a75f7fb632a30e3beaa2060be3f457820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7da984b742fc8d3c88120b14834d59426ec4828aca02628f25819d9ebc5c958b"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    # Run this for pkg-config files
    system "make", "common-install", "prefix=#{prefix}"

    # Build and install static library
    system "cmake", "-B", "build-static", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make", "-C", "build-static"
    system "make", "-C", "build-static",  "install"

    # Build and install shared library
    system "cmake", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make", "-C", "build-shared"
    system "make", "-C", "build-shared", "install"
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
