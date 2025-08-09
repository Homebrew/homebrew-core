class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2025-08-05.tar.gz"
  version "20250805"
  sha256 "b5708d8388110624c85f300e7e9b39c4ed5469891eb1127dd7f9d61272d04907"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/google/re2.git", branch: "main"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYYMMDD format used in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^(\d{2,4}-\d{2}-\d{2})$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/\D/, "") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ad94acc8690fa589ad53200518315e93e785a66f610f55ab0630883165fa131"
    sha256 cellar: :any,                 arm64_sonoma:  "1f313556bf9ed61b8826261017558b4ecff63cac510080aff6d8a82c1b9078a7"
    sha256 cellar: :any,                 arm64_ventura: "59326da0818fa80109b1b775dcd552cf6588358479a516e2aa502a3aaeb69d91"
    sha256 cellar: :any,                 sonoma:        "ce477036ce76d7fb67f9f6f77b0bc7a3a964eee1328a6c81e67ae7a52cadd5ab"
    sha256 cellar: :any,                 ventura:       "daa3b3e9059853c855be8356f3e67a3b4ebd73a60f8a70ed497f332fed67c322"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae030e0501c01faf4c7bffb0d2c4aa46cc15b6b039672a28956c6efc8029afe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a12c60f3928bf307bf4295f8d74fb5963ccdd32ae374b134e390f8def23aff13"
  end

  depends_on "cmake" => :build
  depends_on "abseil"

  def install
    # Build and install static library
    system "cmake", "-S", ".", "-B", "build-static",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-static"
    system "cmake", "--install", "build-static"

    # Build and install shared library
    system "cmake", "-S", ".", "-B", "build-shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DRE2_BUILD_TESTING=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build-shared"
    system "cmake", "--install", "build-shared"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
