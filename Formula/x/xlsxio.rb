class Xlsxio < Formula
  desc "C library for reading values from and writing values to .xlsx files"
  homepage "https://github.com/brechtsanders/xlsxio"
  url "https://github.com/brechtsanders/xlsxio/archive/refs/tags/0.2.36.tar.gz"
  sha256 "80d3df95a7a108a41f83f0ce4c6706873fd2afafd92424fcccea475a8acbd044"
  license "MIT"
  head "https://github.com/brechtsanders/xlsxio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5dcc3ae7f8963c3ee9f56bb2117d666d089e40b801edd882f77d5281ca5c7001"
    sha256 cellar: :any,                 arm64_sequoia: "9181031f8b1370139f5cd5c40698ad29e63d2e907181385c237be46c6a7789e6"
    sha256 cellar: :any,                 arm64_sonoma:  "309fd1194f2edab285b7e492816f61e8fbb342c5ccade5d2613220f6118d48a0"
    sha256 cellar: :any,                 sonoma:        "20a7d4de3d612257ef01593a42db2609dedb3a6e883b65f7cf7b49019bbc9341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bed81fdea13430eae538e69af3e1d984e0a275b71aaacf904abf8f8a1d810dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a8fe52036112b2ed8497ea996965894e3be4eab10c17dbcf106ff46a0f116a0"
  end

  depends_on "libzip"
  uses_from_macos "expat"

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
