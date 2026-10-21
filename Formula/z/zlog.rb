class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/refs/tags/1.2.20.tar.gz"
  sha256 "432723ccd9a5b07ec1e4b8cc985d9011d768633b1e4c4facfc0e3e9a7ad5fcf7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6762b89a3969799654e217d8fd88a14e563c48d1308df70098e1e16610b3fbcb"
    sha256 cellar: :any, arm64_tahoe:       "f31caf504a45c8972ed9cf0940447699c46e5dbb99e21db32d0cf23b69db7657"
    sha256 cellar: :any, arm64_sequoia:     "ea3d476b22dac374ebbc2c4b598301441b3ef46fd17b2b8d94348c79ef3a49bb"
    sha256 cellar: :any, arm64_linux:       "b573ec2caee71daa8165bf01fd09c6539b80df0b67c850c0f2a92e4b06bd80ba"
    sha256 cellar: :any, x86_64_linux:      "506eae9079597d4b3468b85880ed8656db2b6251f3e4254805c434d94e60df24"
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
