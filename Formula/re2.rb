class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2022-04-01.tar.gz"
  version "20220401"
  sha256 "1ae8ccfdb1066a731bba6ee0881baad5efd2cd661acd9569b689f2586e1a50e9"
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
    sha256 cellar: :any,                 arm64_monterey: "37132b360c414438108478cce8b4a2e0f3f0cda6964a0f2234b43db286c2fd21"
    sha256 cellar: :any,                 arm64_big_sur:  "34486668ba2da5ea41ad6fd8a66af1b43ba1b019597c6b44fe7804da093dc80b"
    sha256 cellar: :any,                 monterey:       "62cd468dafec02c1a1c0d28fd93b93364b5ea67f0fdbdcbb3b91044c9a5bfeec"
    sha256 cellar: :any,                 big_sur:        "eed008dc0f16e4e27c6261a485e2de246129fdf2ee6e66c68377bba5a801c0fc"
    sha256 cellar: :any,                 catalina:       "1de4aeb39e788675d4fed079ce848e18bdcda373034030ae282f74f4776880e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42453c1a06530cd54dbcc66dd71f8707eb5c06e15f9233abcbf3aeeb4cc321e"
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
