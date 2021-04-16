class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2021-04-01.tar.gz"
  version "20210401"
  sha256 "358aedf71dbf26506848905f5d4417b7adba5cf44d3bbcf70bf4ef68ccb0871e"
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
    sha256 cellar: :any, arm64_big_sur: "738497c6fee23638e61ce8ccc4b42ca61dfce05d47fcecdcbd1488b567b59ce3"
    sha256 cellar: :any, big_sur:       "aa7b6288f4e59f6fc9a9b7cab7bf20a48bf06ddd4247e14a70cf3dc6fe3bd5da"
    sha256 cellar: :any, catalina:      "01071512713d4ff42a2158f00fce4d3ff6e614729afaa765c29f47980832a8cd"
    sha256 cellar: :any, mojave:        "9fbf16117fa47ac6f0c3b247d13c34f4b1f986e0975cec141414452a6b504864"
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
