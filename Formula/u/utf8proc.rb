class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "6f4f1b639daa6dca9f80bc5db1233e9cbaa31a67790887106160b33ef743f136"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "81533530b545ad8ebf73b33a3bdca4bd7fd79c08b43b36065f01786e303474bb"
    sha256 cellar: :any,                 arm64_sonoma:  "077fcc508fb1911325da5deaea023cfaaf0ca58fdde2097d415779bca397c285"
    sha256 cellar: :any,                 arm64_ventura: "be90c358d69294427f51905783aa6bb9fd9e10f3b5c2fa499f7629186fc61d6c"
    sha256 cellar: :any,                 sonoma:        "94a054d454bd5df62734457a4ac938ab20b3637ae8ee9d36e37fa72fb9adaf41"
    sha256 cellar: :any,                 ventura:       "7086a1eb8b0caa36a1abfad15c613a158ba78800bdfe3f8539d78ad8f10f8a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b814bb33469856d652a662d92121da8b878a2fa3630dda62ba6646d943dae7e"
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
