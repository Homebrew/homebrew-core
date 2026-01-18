class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.11.3.tar.gz"
  sha256 "abfed50b6d4da51345713661370290f4f4747263ee73dc90356299dfc7990c78"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f3b03f1fb1f7da91b28d6b7edb0a8ff056378b689e5c904877dfb6d1cb9da5fc"
    sha256 cellar: :any,                 arm64_sequoia: "3e044d7b72b8fbf7d260cd9a1145cccc32e5f1ad4c93ff7d3cb0e4bd04fa5b37"
    sha256 cellar: :any,                 arm64_sonoma:  "3943b2f6243a92d060a0d1fe867e14ef062db81604488013a0868683c812413c"
    sha256 cellar: :any,                 sonoma:        "ca594194ca639a162e078a88fd0da6d22d0ec8c588f12e3b32545455851aff6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33be13d215561053302eb151cae47d9e3656af6b3869b6a6ca0f044dcf9050e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c44de6245cc5167aa4ec1b8c56d2d2e60378e421db4768a9842283a7602d2561"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
