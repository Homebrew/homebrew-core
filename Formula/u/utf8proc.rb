class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "a9b8d8fd57fb3aeca2aede62fd58958036d3bd29871afc1b871e3916c48420a7"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94d896c25b5923143b9b144a8a81368a0a1681cb660f80cd822d790871aaf13d"
    sha256 cellar: :any,                 arm64_sequoia: "8e8cdcfe7126bf3e45bec8f25ae7bc35e0be0a9af4d01f62568d9d24712d4770"
    sha256 cellar: :any,                 arm64_sonoma:  "b994a8e7634bef43d9ac6491caa0e5607cf26b60d6697865e5155a940e440fea"
    sha256 cellar: :any,                 sonoma:        "a45a23b9e2479f1bd5d77e40e927da55b02c90efa52d60b624b6ca564a616e83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "250f34822e47569f9259e08825ffb05474d53f47069f44b15697943ea992e8df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11c6a84a10fada96f33b3c9c261990dae718b20f74746cfb8d0b55fd090794d0"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
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
