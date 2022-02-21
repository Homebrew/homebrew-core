class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2022-02-01.tar.gz"
  version "20220201"
  sha256 "9c1e6acfd0fed71f40b025a7a1dabaf3ee2ebb74d64ced1f9ee1b0b01d22fd27"
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
    sha256 cellar: :any,                 arm64_monterey: "be3a2099f2704a7eea6d34ce1e5cec66c14d326bac15e27a2fdf07bec73f67fa"
    sha256 cellar: :any,                 arm64_big_sur:  "1689eb21538ee19e08e38b0375b6e3652c348481c77f5edd1689b7fcce5b391b"
    sha256 cellar: :any,                 monterey:       "74d3a79c0f3dbce844594c8bbcfa8626f42fd67c41a724c5c8bc90414f57704b"
    sha256 cellar: :any,                 big_sur:        "75e0f519ff35a091f097fbeb1ea6ca4222e661c3c88b94275b6fdcdbc6dff211"
    sha256 cellar: :any,                 catalina:       "cabc0b7793bb1cbdb453e37efe4b31f96507bc9f2c84304d17614845f34fd365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b31a2d24c951cca0080b6a8450ebeefe285a1ab2f987da0ab9da91e89e959a6a"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    # Run this for pkg-config files
    system "make", "common-install", "prefix=#{prefix}"

    # Run this for the rest of the install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make"
    system "make", "install"
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
