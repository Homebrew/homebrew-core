class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2023-02-01.tar.gz"
  version "20230201"
  sha256 "cbce8b7803e856827201a132862e41af386e7afd9cc6d9a9bc7a4fa4d8ddbdde"
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
    sha256 cellar: :any,                 arm64_ventura:  "dadfebef4f583b9edc77df63d5f909cba4d6ba9d4aeba66565f714eac942078f"
    sha256 cellar: :any,                 arm64_monterey: "c94fc6d3d33c278f1c4deda12b759409399f4c02843f215993847306f866f035"
    sha256 cellar: :any,                 arm64_big_sur:  "07adfba972c07e932db1d00def16507c82591e559db660a2dcab9d43e6a8861b"
    sha256 cellar: :any,                 ventura:        "0d103217e918e5f8ec5e7a049d9b888b317f3be0a5b1bd2fa6e4b11febe1af2c"
    sha256 cellar: :any,                 monterey:       "19b6cf391ae077d6650b8eb0f6dde9961197a88e180bce476aacdcc4b07b09c6"
    sha256 cellar: :any,                 big_sur:        "61fcb9e82f3857e4755b8df8bf84b1b57cadbebc1b116c24b19bdabc0b58d08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ac3544ee880c8417c642ef1eba42fb82ce63c83bc6bae80e93385fbcda79c1"
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
