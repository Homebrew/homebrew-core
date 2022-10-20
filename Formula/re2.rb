class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2022-06-01.tar.gz"
  version "20220601"
  sha256 "f89c61410a072e5cbcf8c27e3a778da7d6fd2f2b5b1445cd4f4508bee946ab0f"
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
    sha256 cellar: :any,                 arm64_monterey: "5364a5325131113abec97c05282f85c29572094ac0ad2cbce9571e1dffd8fda1"
    sha256 cellar: :any,                 arm64_big_sur:  "3d60ddeca55c3d3e629bf2edbf5cfa0b0eeaaf61360b2b9adbde91979c2595ba"
    sha256 cellar: :any,                 monterey:       "568670d04b9bc92a07f6db624acda793834ad1c8bcb2f120386df77d7bd6385c"
    sha256 cellar: :any,                 big_sur:        "e52a5ade3edeaf1d62170e1f4b43a4e73b71178d0e5f91300a4e29442905e7bd"
    sha256 cellar: :any,                 catalina:       "2ca1a5a803d348e1487da767936165a12224b65940de3927e83ccd81c90ed443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6532af8d10af84905b47b7e1fe9db19ae6b2ec9c17bca8c659137f66c56a8a"
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
