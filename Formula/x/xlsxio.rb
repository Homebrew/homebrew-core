class Xlsxio < Formula
  desc "C library for reading values from and writing values to .xlsx files"
  homepage "https://github.com/brechtsanders/xlsxio"
  url "https://github.com/brechtsanders/xlsxio/archive/refs/tags/0.2.35.tar.gz"
  sha256 "03a4d1b1613953d46c8fc2ea048cd32007fbddcd376ab6d4156f72da2815adfa"
  license "MIT"
  head "https://github.com/brechtsanders/xlsxio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7795c447df632aa02bd9962ab025abf10904555e565763d75f811104dcf30421"
    sha256 cellar: :any,                 arm64_ventura:  "15613fb0399f4c22dc5e47013ee3aec14f1c7971d31d7ce24e4113185dd697ae"
    sha256 cellar: :any,                 arm64_monterey: "62b72c1295c012e73f78ca57ae3bef61294e4f4b38cbfe1e97ae24fbaa291075"
    sha256 cellar: :any,                 sonoma:         "99c91608660f9ebc234b5c5c28a6d41e9b6aa832de812fa68e3ec243e5fbca20"
    sha256 cellar: :any,                 ventura:        "bd385c70fb296b74c0cb39017994f297a469c02d093c127d0ce7ef56bd961856"
    sha256 cellar: :any,                 monterey:       "6925d07058e4a7407049cab76bd1658a026a219ce9e4faf9b6d42b13c70e9410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9438d1de48e33e92f6734366f4164281ce6aac33da36b330dd1898f98c14048"
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
