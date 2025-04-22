class Vectorscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://github.com/VectorCamp/vectorscan"
  url "https://github.com/VectorCamp/vectorscan/archive/refs/tags/vectorscan/5.4.11.tar.gz"
  sha256 "905f76ad1fa9e4ae0eb28232cac98afdb96c479666202c5a4c27871fb30a2711"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/VectorCamp/vectorscan.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b360fb4b6e842de1f1aa4599528a0b2bb899f960b6f380fa3acdfaad54f4cec3"
    sha256 cellar: :any,                 arm64_sonoma:   "f39f184ac1f5dbdb22087f8a6fe7ffaadcbb0fdea64d1ea872d2e4df90e28a0b"
    sha256 cellar: :any,                 arm64_ventura:  "52148d0b76b052ffe68ddbf0c23b659fa97498f889e78b49c54db5f12ccd55c5"
    sha256 cellar: :any,                 arm64_monterey: "bc41610e518516717336b23078e5b5b0b2880c5e1a7d6fa72a4d10f1ba8c105e"
    sha256 cellar: :any,                 sonoma:         "19b569e181cf684a889a6be49f77794825e7605d811b4290be9877141133395f"
    sha256 cellar: :any,                 ventura:        "68e0a9783052f829c597b7c45ed425b2e0b5a609cad7eb63a63847e66f9627ea"
    sha256 cellar: :any,                 monterey:       "8e12bb9304fb04e3d8044835916b6d9ab5b5ce15f0183db96d8886a40961caad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e0e99647d8cab29c89b342838b7105590f9439f1933bed206930d4ae31c0a207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "731eccf9091173f46c7578649f8779e9b70ec340572128f69fb1799c9907897a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pcre" => :build # PCRE2 issue: https://github.com/VectorCamp/vectorscan/issues/320
  depends_on "pkgconf" => :build
  depends_on "ragel" => :build

  # fix SQLite requirement check; included in next release
  patch do
    url "https://github.com/VectorCamp/vectorscan/commit/d9ebb20010b3f90a7a5c7bf4a5edff2eb58f2a4f.patch?full_index=1"
    sha256 "e61de5f0321e9020871912883dadcdc1f49cd423dab37de67b6c1e8d07115162"
  end

  def install
    cmake_args = [
      "-DBUILD_STATIC_LIBS=ON",
      "-DBUILD_SHARED_LIBS=ON",
    ]

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
