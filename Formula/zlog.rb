class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/1.2.16.tar.gz"
  sha256 "742401902f2134eb272c49631fe5c38d7aeb9a2ad56fa3ec3d15219b371ba655"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b1c7b07083c3667fb8f32eba4437d2f3f7c872a184476968963b902a8a850aac"
    sha256 cellar: :any,                 arm64_monterey: "16588f7d867f7426696693b19ee0221ff7483c2d7a34a856e3acb32c46c8ea41"
    sha256 cellar: :any,                 arm64_big_sur:  "04ed8b2ebcbbf23a3e6ad76b8d80914f939e6fc6cadfd297b91c3d4d1d29b8b0"
    sha256 cellar: :any,                 ventura:        "f76ab42f65f676cd34a153fcac5c8a543edce5dd6bc462700dc23f0e99000b68"
    sha256 cellar: :any,                 monterey:       "19cf707f5b5720aefa8f7cbb851a032a9a16900b7b17685530aa59081cbb0ee5"
    sha256 cellar: :any,                 big_sur:        "f1384547bacef98381ae766dc90efc690a6a2a87dca0763a0572a3288ad68aee"
    sha256 cellar: :any,                 catalina:       "62f3fbab6a72eb27a201c1c31cdb2cf8d4170053fdbfbe27130452026d01da69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204935c1271f0c1cca1543ba6e71f7b1fcfcb611b97c6b32057c452abc1c2478"
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
