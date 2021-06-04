class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2021-06-01.tar.gz"
  version "20210601"
  sha256 "26155e050b10b5969e986dab35654247a3b1b295e0532880b5a9c13c0a700ceb"
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
    sha256 cellar: :any, arm64_big_sur: "fd9573e36089968186676dfbe4a7af7dfb7ef7049d0523de68c890de509ab2c9"
    sha256 cellar: :any, big_sur:       "6f4a0ffc9a7a09aea3cf7acfa84b5ebe5ab7834f6a55d6f586e15242ea05d317"
    sha256 cellar: :any, catalina:      "7170869b764314dd7804bc4d234215965725356739fffd99279f2d4690cf6bc8"
    sha256 cellar: :any, mojave:        "9587952072674b6432c3bc0c6cdf1200cb5041e154025e13de78c8628c3493e2"
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
