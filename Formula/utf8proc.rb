class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.7.0.tar.gz"
  sha256 "4bb121e297293c0fd55f08f83afab6d35d48f0af4ecc07523ad8ec99aa2b12a1"
  license all_of: ["MIT", "Unicode-DFS-2015"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "72863230e3a49a319ccf71db211b7866decc25b424c24b57a6e3417211222c90"
    sha256 cellar: :any,                 arm64_big_sur:  "d7b7ee1475f28c34e6702a93bf9fb16abaa49fcd84bdb28c3d07a8d13040f4a6"
    sha256 cellar: :any,                 monterey:       "43f71ce7d7399280dfe784c8c10091d33d4fcd3680366720ea56c8c5d3c8330c"
    sha256 cellar: :any,                 big_sur:        "459ccaa0dae192d1c8b1f181090ab2a1712c0cb2aebd445e91d3fc92124783e4"
    sha256 cellar: :any,                 catalina:       "9d2ebee54aeddd64fd8189efe788a388e26482c2ff334ab4e85057861f1e948a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e820113377424418246a2ce4bfba88f9241fd8c456673a313b7f9b85f55cf3a5"
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
