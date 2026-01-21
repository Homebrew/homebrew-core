class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/releases/download/2025-11-05/re2-2025-11-05.tar.gz"
  sha256 "87f6029d2f6de8aa023654240a03ada90e876ce9a4676e258dd01ea4c26ffd67"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/google/re2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d{4}-\d{2}-\d{2})$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3d8133e1af82433fd8491050aafc3cdf81e2728c1d171818e187001f5c5efb1"
    sha256 cellar: :any,                 arm64_sequoia: "9dfd8e748444eb04b1180dfa861cef831d720588d016051c60bf1b9bc77bea4f"
    sha256 cellar: :any,                 arm64_sonoma:  "2417787aad7998e86107097674b67fa1f32bed1eadc7a60261f6f1a024a1c55a"
    sha256 cellar: :any,                 sonoma:        "336269669bfd8cab867b5ea69d99706e2b73dc0fa796ac987f5ad665010735cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74f2417e6840a1af5020085db3513cdc047e5dbe24bf9213871eb388b2af6bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d2b0fa3b0b1954bd06ca343641936d0d0833d0a80a7aa543eaca0a95332c055"
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
