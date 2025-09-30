class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "c24379b5fa0a429a1f9a3fc23b44a75f2b141a34c09146a529a55d20a5808070"
  license all_of: ["MIT", "Unicode-DFS-2015"]
  head "https://github.com/JuliaStrings/utf8proc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0adfed95cc97ea5bc7c47c8092751384bd19b1e0d8106156371b3450141af5ba"
    sha256 cellar: :any,                 arm64_sequoia: "c0b3f0ba16f271e968b9997d28376af5ab4ad892635e9e03680a04a969fff582"
    sha256 cellar: :any,                 arm64_sonoma:  "9c20559a53854e3621a707a2ac212252fc38e07d1d8becf463eb41d00296db6c"
    sha256 cellar: :any,                 arm64_ventura: "94453c744f5af4f41a6dc1559b317ca3ada968e1cc7de14397307db73d8eeb98"
    sha256 cellar: :any,                 sonoma:        "e4cee72016fbf5a9d60ba840db4f990f9445f7678d1085d77f25333b59a5b1c8"
    sha256 cellar: :any,                 ventura:       "d7bf494ab688bbe9228b8417482cef6de6facefb14138f9fb0b77a77ebbce5c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff2d7961db74b2c8b9410c611065d68fa4f37528494fd1511818f53030a3dc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eceec934bae4b7682d8c751d7242322b51c9d0521969471037b1bc4135fe1f40"
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
