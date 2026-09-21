class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/refs/tags/1.2.19.tar.gz"
  sha256 "475df1b30be64190fd692de834ad4c45510f996188b5ecd4b6e3da2527c74a32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b7acd797537992097538927b710515616f0d9242c833505f3253aa393326184"
    sha256 cellar: :any, arm64_tahoe:       "68df05708e497ba44e05f9a29ae69300e80828d8d9aed525be3339d1c2a1c992"
    sha256 cellar: :any, arm64_sequoia:     "12c23c9213302e0f2d37bd0dd8054d61759e24845677afc271be2ee3ce07e67e"
    sha256 cellar: :any, arm64_linux:       "b67c8df75531aa96bbe34618e711dd0f908fc9c4ca219f042afbb49bfd426398"
    sha256 cellar: :any, x86_64_linux:      "a6812c10fbf7026cb9dd067b20eb7785dd232915ebb420581060a0385c12cf81"
  end

  on_macos do
    depends_on "make" => :build
  end

  deny_network_access!

  def install
    make = OS.mac? ? "gmake" : "make"

    system make, "PREFIX=#{prefix}"
    system make, "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"zlog.conf").write <<~INI
      [formats]
      simple = "%m%n"
      [rules]
      my_cat.DEBUG    >stdout; simple
    INI
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lzlog", "-pthread", "-o", "test"
    assert_equal "hello, zlog!\n", shell_output("./test")
  end
end
