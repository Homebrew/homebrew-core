class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/releases/download/2025-11-05/re2-2025-11-05.tar.gz"
  sha256 "87f6029d2f6de8aa023654240a03ada90e876ce9a4676e258dd01ea4c26ffd67"
  license "BSD-3-Clause"
  revision 2
  version_scheme 1
  compatibility_version 1
  head "https://github.com/google/re2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(\d{4}-\d{2}-\d{2})$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e96aaf1115b4b532ec7f59ee986372c2d0ab7b0eb27ff41d5216e1a4f3957ef"
    sha256 cellar: :any, arm64_sequoia: "41a23f8a657a72326621e241bab27e53bc1105c34dbe1528beae97a5b2fd3b51"
    sha256 cellar: :any, arm64_sonoma:  "6aefa9488158d9c8f096e2a802e9a755e68356e82f99a88adfe763af4769b88d"
    sha256 cellar: :any, sonoma:        "dca2f070c420737d68abb0af8108c35fe8355796acd675bff8dbe8ab94e2756e"
    sha256 cellar: :any, arm64_linux:   "21373cdf8b18b43c0139d1f62fe758b00b9ca11fd2c4ebb77836444eaa954dbe"
    sha256 cellar: :any, x86_64_linux:  "b743c2a713b079e718ef7d6af0cadc118faa6dc9039bb8ad6fe72b8f60fdd6bd"
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
