class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2021-08-01.tar.gz"
  version "20210801"
  sha256 "cd8c950b528f413e02c12970dce62a7b6f37733d7f68807e73a2d9bc9db79bc8"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "3951877486d2ce0e2c539f69f192b42d881160446d0657c2f212800d4fa47885"
    sha256 cellar: :any,                 big_sur:       "bf681152897e7d95030d6c6d5768c8a62acefa030400b7d0b101550d684af2d4"
    sha256 cellar: :any,                 catalina:      "f5fa3c199ea233cc5113c8f9828019718977a84dee59aa4b80a423db407fb387"
    sha256 cellar: :any,                 mojave:        "094976a778bcb6a57051bf8a14f234a531660c612d1727114d8e0ee0d23c17cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43e63ac2cf837e60e7b9c0a62ca9650f7b99d8e2647ae658b16fd39ce4d54f3d"
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
