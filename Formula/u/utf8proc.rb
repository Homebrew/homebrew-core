class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.8.0.tar.gz"
  sha256 "a0a60a79fe6f6d54e7d411facbfcc867a6e198608f2cd992490e46f04b1bcecc"
  license all_of: ["MIT", "Unicode-DFS-2015"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30ed86d43d46f716a4a1b72387914314e4a59340e1baa4fbb737af16c3307d08"
    sha256 cellar: :any,                 arm64_monterey: "509a6e2796a043ba5fcc913adf088330edd7b0196d80a9978de685757f113b8d"
    sha256 cellar: :any,                 arm64_big_sur:  "42a02f08806443010d52cfe20390fde9e0a20b995f0cee8aaf1ff69761dee632"
    sha256 cellar: :any,                 ventura:        "205b140d52a4e1c1fe8ff42514f95b230e7a9542789a7eb1da599b454aefd7df"
    sha256 cellar: :any,                 monterey:       "f6e51a50dc42de33bca46db0dc1a065c417a3ade6dc812cf184da6ea88bc48d8"
    sha256 cellar: :any,                 big_sur:        "e1572b897d7f68c664ff54d8b701f1f839c909bd10ea8d47cc5ea221cbc39018"
    sha256 cellar: :any,                 catalina:       "a4985025c7b99050f9f136d13de2446a77d2d36f8067469c7ac11813be9848ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f445634d879944ce4965d2c0c022859fd3f8c15022e96ab51e4257cbc5d6376b"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
