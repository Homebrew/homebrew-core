class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2023-02-01.tar.gz"
  version "20230201"
  sha256 "cbce8b7803e856827201a132862e41af386e7afd9cc6d9a9bc7a4fa4d8ddbdde"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "67225a4866cd4f1157524eb233f001c48c7ed8cd70acbad9e31a1c4ab9cc4a51"
    sha256 cellar: :any,                 arm64_monterey: "ad347b8ab8ef98f7e530cdbc3135c87ee286fa0dce29be6f01413769365630c7"
    sha256 cellar: :any,                 arm64_big_sur:  "f5a29c55f147290d74658a73d013f3bee923d4598acd08314393e4bec72ef926"
    sha256 cellar: :any,                 ventura:        "16ee8ec04aee7cd800a73fdf24028140748e38d301cae2533764932870dbe6f7"
    sha256 cellar: :any,                 monterey:       "f57dbd96ba41c7c6b7e4abc77b73cc80177631cbbbf113d82c4b879d57980825"
    sha256 cellar: :any,                 big_sur:        "00e6e5628dae6ae1d65adb10cf2e7d99f0128393a54232560d4fc11d29c0f66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e18162c945c00acb928cc64e1fe0fea11c3089d23dc3636d1bfd796230cb9e6"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    # Run this for pkg-config files
    system "make", "common-install", "prefix=#{prefix}"

    # Build and install static library
    system "cmake", "-B", "build-static", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make", "-C", "build-static"
    system "make", "-C", "build-static",  "install"

    # Build and install shared library
    system "cmake", "-B", "build-shared", "-DBUILD_SHARED_LIBS=ON", "-DRE2_BUILD_TESTING=OFF", *std_cmake_args
    system "make", "-C", "build-shared"
    system "make", "-C", "build-shared", "install"
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
