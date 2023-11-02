class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2023-11-01.tar.gz"
  version "20231101"
  sha256 "4e6593ac3c71de1c0f322735bc8b0492a72f66ffccfad76e259fa21c41d27d8a"
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
    sha256 cellar: :any,                 arm64_sonoma:   "5284e881c685c63ebe4eb050a5c142411c5e985b75cc14071e2fa5d86b22cbf6"
    sha256 cellar: :any,                 arm64_ventura:  "83f5eb2c99beceb45f93b35a9058d1c556605c21bc2382ebe01b88a9937e5e05"
    sha256 cellar: :any,                 arm64_monterey: "b1bc82f91411308a1e7dd0a58655d1eee47e38a0b119efec10bf080107818f51"
    sha256 cellar: :any,                 sonoma:         "3758b54970292370b1b60583cf131f9dde94c49c0f1f340a8002b902a28f0872"
    sha256 cellar: :any,                 ventura:        "772ecee379c6a29b5b770bd734c82b753c3fb46cda73fd705a2d4520332e313a"
    sha256 cellar: :any,                 monterey:       "82d0ac3196c8beb1b0246d2149b374e7a170f29d24c5405c2c3efe775e4a1882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb4465aef8884e998af0d2f965124d7c747eb2b9d2dfc6b9ab88b714208c18df"
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
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lre2"
    system "./test"
  end
end
