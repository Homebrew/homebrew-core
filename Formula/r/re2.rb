class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/releases/download/2023-08-01/re2-2023-08-01.tar.gz"
  version "20230801"
  sha256 "d82d0efe2389949244445e7a6ac9a10fccc3d6a3d267ec4652991a51291647b0"
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
    sha256 cellar: :any,                 arm64_ventura:  "4eecae9eecb0319c810d64926a7b30656f193782cfe5911afb43f13b80f53a02"
    sha256 cellar: :any,                 arm64_monterey: "7a256d2736302fb852387f831b07e1150036594855f07816d56b7562cea6eda6"
    sha256 cellar: :any,                 arm64_big_sur:  "647515404050358cd650f686bd4961d8c16b30138c89b8a5ac45efc4dcedfc36"
    sha256 cellar: :any,                 ventura:        "73692d848436c7d723427e5ba75195675961602c8558a9c8657899b57ab271e9"
    sha256 cellar: :any,                 monterey:       "ebe2ea0e7bb45c7ae9bb58d18cbeaf45f9ddcc41360b5d0a9abc669e56cfbc98"
    sha256 cellar: :any,                 big_sur:        "1dbe5727496145426c23ea37cc611b5d293d3ca588604af157cc67527af1b9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0296fbf31ec225f613c291c33ee60cf8087ffbe703f2d1dddbf2cd0b153ec738"
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
