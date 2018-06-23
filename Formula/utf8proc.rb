class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://julialang.org/utf8proc/"
  url "https://github.com/JuliaLang/utf8proc/archive/v2.1.1.tar.gz"
  sha256 "27702f369f3545144470b277cd8369a7997ba4292a48a28be154c3aff28bd7b2"

  bottle do
    cellar :any
    sha256 "87cb1cce4137754f0ebf386ab699645de96399bd172fc718c8646948a596aa1a" => :high_sierra
    sha256 "ce61a07cd731b8c3edac281c8d43545bf2b12a96be6b488bb7f4b6b153d2853d" => :sierra
    sha256 "ee9ae01f0ea9fb18d0761151a6d1e386f7a15c34e8d83ebac0aa88eb39d486aa" => :el_capitan
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
