class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2021-02-02.tar.gz"
  version "20210202"
  sha256 "1396ab50c06c1a8885fb68bf49a5ecfd989163015fd96699a180d6414937f33f"
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
    sha256 cellar: :any, arm64_big_sur: "d5d10c0775f70740b3c6500824d18e01f5b29c5ed98291ee52b53107db6f6a8d"
    sha256 cellar: :any, big_sur:       "65a30882f68414d1a9d5b08f6f452a0091460bcc062962789e9585652de04164"
    sha256 cellar: :any, catalina:      "de7bad8a1ea4cf5b8ab0b32463160321aed137e4864d0c81e7b298cf4f8a8164"
    sha256 cellar: :any, mojave:        "7d98093a112270677f4f5a76cedfd2432af1464f3c69c4cf5f8d554997f49513"
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
