class Xlsxio < Formula
  desc "C library for reading values from and writing values to .xlsx files"
  homepage "https://github.com/brechtsanders/xlsxio"
  url "https://github.com/brechtsanders/xlsxio/archive/refs/tags/0.2.34.tar.gz"
  sha256 "726e3bc3cf571ac20e5c39b1f192f3793d24ebfdeaadcd210de74aa1ec100bb6"
  license "MIT"
  head "https://github.com/brechtsanders/xlsxio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4a4ae609f94e1caba2512020665977c99a6c5cac293527a28fcff4a445353988"
    sha256 cellar: :any,                 arm64_ventura:  "56c7fa7ec1da583535d5effabb7226d828f497501ce54104bb7154584b47de19"
    sha256 cellar: :any,                 arm64_monterey: "684dd876731be71b25aedf3dcf35e1f56041444b70f91619d04bca5ef2f83bdc"
    sha256 cellar: :any,                 arm64_big_sur:  "3f5990bbf6820eeed17c52b458d90aaa46662673f57467e5d42ac6795000fad3"
    sha256 cellar: :any,                 sonoma:         "2e40c04a1471ba95b7c18591ef3b177737f3b9b0e235f8a0b60413a300f5206c"
    sha256 cellar: :any,                 ventura:        "8b7adb558e5a28b157c01ff2560b0fcf7fbd0d087ceb0ee225a0036b25c33a40"
    sha256 cellar: :any,                 monterey:       "6fdc5c9d184f6fd6af07aea182d295e4ac81072b95e625bfbd25c38829fc134e"
    sha256 cellar: :any,                 big_sur:        "0a3920eb3bcc417d80d78948ae01b746ec74e7213cd33a6066a9990a1c079f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f66d061d5d7b64aac85eeea619e224ef9412302f80225dd6ab11f183904327"
  end

  depends_on "libzip"
  uses_from_macos "expat"

  def install
    system "make", "install", "PREFIX=#{prefix}", "V=1", "WITH_LIBZIP=1"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxlsxio_read", "-lxlsxio_write", "-o", "test"
    system "./test"
    assert_predicate testpath/"myexcel.xlsx", :exist?, "Failed to create xlsx file"
  end
end
