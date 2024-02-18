class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2024-02-01.tar.gz"
  version "20240201"
  sha256 "cd191a311b84fcf37310e5cd876845b4bf5aee76fdd755008eef3b6478ce07bb"
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
    sha256 cellar: :any,                 arm64_sonoma:   "449a2574e5176bba9ee0083df70a771f8896755ded690fa834d1b34e8c7cd5b9"
    sha256 cellar: :any,                 arm64_ventura:  "8e3116d6a49b76af5f0e26dcb0aa65c1649bc44c797736137c03db3376ae5fee"
    sha256 cellar: :any,                 arm64_monterey: "dd68535374ccc86bf9884afeadd81c1a9a58d6a6a220b9924abe38c9b515a71f"
    sha256 cellar: :any,                 sonoma:         "c42018fd50d387154925225770cd507716db373275ca55ddfcb7d52e129feda4"
    sha256 cellar: :any,                 ventura:        "30f1edea42afffcfe7ea739e1dd6562f7c86711d4d6d882103ba5218dbdd775f"
    sha256 cellar: :any,                 monterey:       "fc7d697be94601f084f35e497637b9d631b0e897786cbf54cb24277b9c6493fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc0c1f75d2b1ea3ced3c2a9cfcf5fe5f853f419b4b90dd9171b54a969315d00d"
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
