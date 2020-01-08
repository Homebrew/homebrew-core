class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/1.2.14.tar.gz"
  sha256 "05a6533e32f313eeaf134a761481a5cbc586c5dc85ba9ee6771c7458daaeb031"

  bottle do
    cellar :any
    sha256 "410b5b25a6937ee4a2b857abe59182118ca15f126ad3db63783543819677b4e2" => :catalina
    sha256 "53397021c310a023186a827e409f89579dcc9e4a2476aa692c8fc999ebed5365" => :mojave
    sha256 "0947510004f20981a16c25a95fb680826f56d884cc48a05c775179bc5bd17f82" => :high_sierra
    sha256 "ac9057902240d755b3e57c3cc599dec9e1aa769a2bb83b07576d24f73fbe6ecf" => :sierra
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
