class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2021-02-01.tar.gz"
  version "20210201"
  sha256 "d3e15031ced791b39f11964816ca2d4213f25d3b67fbbe82972c7b7666c456ba"
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
    sha256 cellar: :any, arm64_big_sur: "13f404afed47230c0e201c243b9b56c73ad36f06f0f9585270b9f9dce05d60de"
    sha256 cellar: :any, big_sur:       "358867c4ccf2d5f6ca6c87f1a228869937e0cd569e7c3ccb3e25466458e47b65"
    sha256 cellar: :any, catalina:      "4879622aed1b28e66c1da31683c7bc19c287e7aded0cb0309df5186c7620cf7b"
    sha256 cellar: :any, mojave:        "e67b8b92889ec6c0f70f37c9bcb171cc0f8e7d9fcc0a76842c92507372b90cfe"
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
