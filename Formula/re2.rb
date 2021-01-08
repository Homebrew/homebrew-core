class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-11-01.tar.gz"
  version "20201101"
  sha256 "8903cc66c9d34c72e2bc91722288ebc7e3ec37787ecfef44d204b2d6281954d7"
  license "BSD-3-Clause"
  head "https://github.com/google/re2.git"

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
    cellar :any
    sha256 "02fed353151f3d3d936af926e1fcd18cd68ca0e51694eb48acccbc5280316ce2" => :big_sur
    sha256 "0a41585c7bd946cd0b427533c79c272cb5ba7b031054d3892ca0bd9763cc6749" => :arm64_big_sur
    sha256 "3775e06cd4478f7ef90cfe76bbd01d051c8ba2b646fd84601e307a8c0e2ec7de" => :catalina
    sha256 "621f2bcea8c2f42d3ddb2de7f3df669259b5818763290d7b957c6bd406102a45" => :mojave
    sha256 "6be4625dab709d29564e85823b24c668c1b7fe061365d443ac4956f4ad3135fc" => :high_sierra
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
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lre2",
           "test.cpp", "-o", "test"
    system "./test"
  end
end
