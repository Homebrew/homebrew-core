class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2025-11-05.tar.gz"
  version "20251105"
  sha256 "87f6029d2f6de8aa023654240a03ada90e876ce9a4676e258dd01ea4c26ffd67"
  license "BSD-3-Clause"
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
    sha256 cellar: :any,                 arm64_tahoe:   "0529b431de81bc292e81fb08238a99601ee5aba8f42aed78e6fe5bacfcf580b8"
    sha256 cellar: :any,                 arm64_sequoia: "6ba2f2a97afd7c09910638e2f714a4aec43385583e09703fc14e1862f6870c01"
    sha256 cellar: :any,                 arm64_sonoma:  "bca9b2b0b60ed7dbfde82a3beb8a3383e90be2b3fadf5114bbeca35ce459d99c"
    sha256 cellar: :any,                 sonoma:        "1fdfab2bdfe78e47ab2791305c14ad69f73b9491772f0c6c037aaf33414bcce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c042a6c01aa7ac1bba39b586d933a6cc60d2a00f2cbe35efd7b70a7fa201b2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2d28f82483022a00c6f9415de2b69cecdcd03d5597943eccdb77e96a9ca6ac4"
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
