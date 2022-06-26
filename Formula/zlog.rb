class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/1.2.15.tar.gz"
  sha256 "00037ab8d52772a95d645f1dcfd2c292b7cea326b54e63e219a5b7fdcb7e6508"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3328780426e5d4b751d8e2d2be3e521443426e60ab2e3acc0738e4215c846b88"
    sha256 cellar: :any,                 arm64_big_sur:  "d2798cae6a89a001fed3fafe113fd26594d34c6c2d61d08fcd1e84ec513fb889"
    sha256 cellar: :any,                 monterey:       "025232893c2e856b7551f64659c4250b724b903c6fd18b7af2d8575658b68dad"
    sha256 cellar: :any,                 big_sur:        "07b323ff8ba13c92bf8c720b6fd0a760a776b5e9d6f46356700066ef2b3643a6"
    sha256 cellar: :any,                 catalina:       "31352f21933854c635450c9cc5c00f1dc1370a62a331a691879bea2eaba45582"
    sha256 cellar: :any,                 mojave:         "170ffd446913b23c344d82160c19bfb1c8325c07dc31490a636e72345abe1c7b"
    sha256 cellar: :any,                 high_sierra:    "332ed23525b10970bd5bc81052bae67755aee5f2651fdaafed5dd036da470239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54d50cc28304b4841a04e49e269eef63c28be2be50031119ddf80cd1fb9ec2fc"
  end

  def install
    system "make", "PREFIX=#{prefix}"
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
    system ENV.cc, "test.c", "-L#{lib}", "-lzlog", "-pthread", "-o", "test"
    assert_equal "hello, zlog!\n", shell_output("./test")
  end
end
