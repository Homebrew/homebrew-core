class Xlsxio < Formula
  desc "C library for reading values from and writing values to .xlsx files"
  homepage "https://github.com/brechtsanders/xlsxio"
  url "https://github.com/brechtsanders/xlsxio/archive/refs/tags/0.2.37.tar.gz"
  sha256 "b9fcb22e124d178f30d404e5a22ccac594353d71d845035795321cd53d6c4cee"
  license "MIT"
  head "https://github.com/brechtsanders/xlsxio.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7bfc6c609dd08087a0d0a283f0e32dda0fff4c9b3e19081c3247339f9c7a98db"
    sha256 cellar: :any, arm64_tahoe:       "84639a155e0ec672d19512ffcbc22cab7015158ccf1bbbe0d77607f85dc78b91"
    sha256 cellar: :any, arm64_sequoia:     "8cdf01051bb1beabf8dfa3bf3836b053e1eccfe128e93fd850b33db851469333"
    sha256 cellar: :any, arm64_linux:       "77f2ce544f40c2f2f0aaf914211cffa4421e855e8c48a5dea3eaf591c1039cb1"
    sha256 cellar: :any, x86_64_linux:      "b51c8dc8a3c46d6bc34abe19eac5db797b35b1fd41e75889db50f6b02c206914"
  end

  depends_on "libzip"
  uses_from_macos "expat"

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1", "WITH_LIBZIP=1"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <stdio.h>
      #include <unistd.h>
      #include <xlsxio_read.h>
      #include <xlsxio_write.h>

      int main() {
        xlsxiowriter handle;
        if ((handle = xlsxiowrite_open("myexcel.xlsx", "MySheet")) == NULL) {
          return 1;
        }
        return xlsxiowrite_close(handle);
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxio_read", "-lxlsxio_write", "-o", "test"
    system "./test"
    assert_path_exists testpath/"myexcel.xlsx", "Failed to create xlsx file"
  end
end
