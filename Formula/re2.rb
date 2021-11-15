class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2021-11-01.tar.gz"
  version "20211101"
  sha256 "8c45f7fba029ab41f2a7e6545058d9eec94eef97ce70df58e92d85cfc08b4669"
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
    sha256 cellar: :any,                 arm64_monterey: "411d3fd746a54b73c5cfbf4554197d3529a6bc5d74db706edc2973bceb32ea47"
    sha256 cellar: :any,                 arm64_big_sur:  "debe0b67ea263d4e1cfcb7a7a85a4d70e5db4bee54971daca718c8245b435cfd"
    sha256 cellar: :any,                 monterey:       "e3750181b190e53efdc2fd2c1f3f6199d0648e993f2c8e7f3de618b8417a228f"
    sha256 cellar: :any,                 big_sur:        "ee81d89700feecc8ab081c65aa0e6317ae1b580e33736687e10f2a0f8fa6b788"
    sha256 cellar: :any,                 catalina:       "d3e0fa175a17e9a9b9e624113eb41b44a579829be8d6736e9ae14fb466493ef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f77942403dca071176d50096e88737a548d1c9e5c90df19202c26aa05c7e2a6"
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
