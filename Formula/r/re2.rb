class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2024-07-02.tar.gz"
  version "20240702"
  sha256 "eb2df807c781601c14a260a507a5bb4509be1ee626024cb45acbd57cb9d4032b"
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

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "78c39b1bdfc21ac31d89fc69ef35cc28fe7deabd551c3b3ec29c0f200c56c7ae"
    sha256 cellar: :any,                 arm64_sonoma:   "9dc85bc8e5a00a1a642331e812871dc00ed4a272a8415ec523f278d0dbb1faab"
    sha256 cellar: :any,                 arm64_ventura:  "5dd906163941f74bc6c69a3cfedd5ebc9c7dc46d7edae24ade05301d57213047"
    sha256 cellar: :any,                 arm64_monterey: "f4605e85f6e65e78edc7235bcc3e94af9f14f085a917f1439eb1cdd925f21c43"
    sha256 cellar: :any,                 sonoma:         "3a4ded074a9b16c0989fa50cad39ca056d58f97aabf7727842225b5842f6aeed"
    sha256 cellar: :any,                 ventura:        "25f162c211fea6e9809c3bd9a8f629815dbc8210bc5a463f774b3adf5f1d630b"
    sha256 cellar: :any,                 monterey:       "a5bad9ec8a9c26b3f5bfc8c1ef9427dd26323bd653a8283fdba5705a8cfca859"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2ce851d198aa1ed70bbe6a431fbab0b3bc08fc166b66cd23e20f09e3d25f19df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e12fc1cd41b67cd68a6b8f4c1a925b1027eb8a6528ee2bb140477dcdc7ac445"
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
