class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  # Canonical homepage is https://julialang.org/utf8proc
  homepage "https://github.com/JuliaStrings/utf8proc"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.2.0.tar.gz"
  sha256 "3f8fd1dbdb057ee5ba584a539d5cd1b3952141c0338557cb0bdf8cb9cfed5dbf"

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
