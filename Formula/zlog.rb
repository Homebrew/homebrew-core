class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/1.2.12.tar.gz"
  sha256 "9c6014a3f74d136c70255539beba11f30e1d3617d07ce7ea917b35f3e52bac20"

  bottle do
    cellar :any
    sha256 "10b13197cf780ee263ce305b1d48bb005231110601d7d1e4a3c3e4d1e2e38598" => :mojave
    sha256 "8c69d89489366fc6fbb92af4f89ed34dd82e44aea0587591998a52dc2d43392b" => :high_sierra
    sha256 "88179deeaf4acb8638c155acc887661da3eb191e05b23ecd6c64757ffaedb6d9" => :sierra
    sha256 "c18ad86b3c5f8721f18a1090e6d372564a89ac972d1cfaa8a6819c5ecaec25ee" => :el_capitan
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"zlog.conf").write <<~EOS
      [formats]
      simple = "%m%n"
      [rules]
      my_cat.DEBUG    >stdout; simple
    EOS
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <zlog.h>
      int main() {
        int rc;
        zlog_category_t *c;

        rc = zlog_init("zlog.conf");
        if (rc) {
          printf("init failed!");
          return -1;
        }

        c = zlog_get_category("my_cat");
        if (!c) {
          printf("get cat failed!");
          zlog_fini();
          return -2;
        }

        zlog_info(c, "hello, zlog!");
        zlog_fini();

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzlog", "-lpthread", "-o", "test"
    system "./test"
  end
end
