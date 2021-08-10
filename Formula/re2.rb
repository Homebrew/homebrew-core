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
    sha256 cellar: :any,                 arm64_big_sur: "7161e24d4d5b9330079b6ec2915f6b4930dc97ab60c2b33f997865828f79e3b7"
    sha256 cellar: :any,                 big_sur:       "d02415b9f89466ecba729540c2a0a4aba73b6d2c93795ed9688958e5fd8d2483"
    sha256 cellar: :any,                 catalina:      "43fd15aaa2999e110b460b4503c7437b11fe7d92f681056f2d36b508026715b5"
    sha256 cellar: :any,                 mojave:        "97101f6e275debb9544d1b7dbfe7b5be28160bc1197ef3f7c0d340e834748dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9853243831ee5b158e338b1d4aef131e993efeb0c1ca7f3fde050eb07404588"
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
