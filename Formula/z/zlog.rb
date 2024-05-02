class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/refs/tags/1.2.17.tar.gz"
  sha256 "7fe412130abbb75a0779df89ae407db5d8f594435cc4ff6b068d924e13fd5c68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e1c8fc12f6ca10885f95e4a8679dd2584d397bdfe60ba70281329e7a1e11204d"
    sha256 cellar: :any,                 arm64_ventura:  "2d9322f96b62089204e0e2cd678942d35df790d2195b9402533aa0da495abe6f"
    sha256 cellar: :any,                 arm64_monterey: "27debda881311329213187c060b2029122d939bc355f988000c9a73a410ca01d"
    sha256 cellar: :any,                 sonoma:         "230642455c764960cfb097b80793cf5b04e417eda975638ea537a3f39b4924d9"
    sha256 cellar: :any,                 ventura:        "00753664bd8dddc742ff431f821559d7f56b6d061bbffa5e8bdeebe5a82dda29"
    sha256 cellar: :any,                 monterey:       "6d31422019f2bb265e13755d85ec9ba47d70d05833852badf8f57c6a0eed664b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78c9e0d1d1146eb99895e8736cf8fae032ad537193df9bdf5d6f6523559e8627"
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
