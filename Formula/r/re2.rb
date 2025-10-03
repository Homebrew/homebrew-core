class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/refs/tags/2025-08-12.tar.gz"
  version "20250812"
  sha256 "2f3bec634c3e51ea1faf0d441e0a8718b73ef758d7020175ed7e352df3f6ae12"
  license "BSD-3-Clause"
  revision 1
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
    sha256 cellar: :any,                 arm64_tahoe:   "ff728da4d5c417e3412d0713846b06c4aadfac16130be2731f5826173aa684f5"
    sha256 cellar: :any,                 arm64_sequoia: "55dd029d2e6c7a466bced9d25336943ce0f2cee303417ede765d188e3b110cf7"
    sha256 cellar: :any,                 arm64_sonoma:  "e8855b22823e960f98d6f0d43947fb7a4ad1b9ed9cee487bbb59e57cdcb7e5af"
    sha256 cellar: :any,                 arm64_ventura: "8e907a1fe489e9d5d07635364d1639aa670d15d149d4a3a1ffc141d28c2c6a6d"
    sha256 cellar: :any,                 sonoma:        "1b4225bec7a3a0d486e8935894b425c4919d48b38f9df43fe3ad0d346cab9246"
    sha256 cellar: :any,                 ventura:       "a33952db79252f40d49541050612303ebe3ad5efdc41e57fae2a5f7289ec7f84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eab07e068468b3efa6beb394d8f97dce0f86186e3a44a20d70c701f7d23dcf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be87e985f9cbfd6152865d81d7fbed47609f3b9129fa4282326b32389f18a1b1"
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
