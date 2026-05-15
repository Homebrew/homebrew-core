class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/refs/tags/1.2.18.tar.gz"
  sha256 "3977dc8ea0069139816ec4025b320d9a7fc2035398775ea91429e83cb0d1ce4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e71ea809671f98c7c971dd32bb10b6277631f2216ad5c47b3742449c07f0c2f0"
    sha256 cellar: :any,                 arm64_sequoia:  "048b4b3e71147569f94ac5a81fcaabe259d313f81bc0634617737fbb3c38e98e"
    sha256 cellar: :any,                 arm64_sonoma:   "37e945fe1dd889750af896e816c0790db9b18f3a534772cac3d2be22e720b637"
    sha256 cellar: :any,                 arm64_ventura:  "5553716576ac0457c4fb359f1f5a68304ee9801b7741a29d14d20ef7d2f45791"
    sha256 cellar: :any,                 arm64_monterey: "d88d92564bd205190476a208b4bf684f20e6f4c8390c050a42a4e8acf31cc0b1"
    sha256 cellar: :any,                 sonoma:         "fd76e9b11c931478c0106c32c4f67feb6f5c1ddfd10cdf985278ececff977aa6"
    sha256 cellar: :any,                 ventura:        "3a641c10f7447de85a8b04d1c283aa0b9804efd9feb73115b68afd2cd06f13cf"
    sha256 cellar: :any,                 monterey:       "84cded237749c8ffb59d04d0426765cf86f42beefe415e54fb6ad99508c7f247"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2262180dca42195cb202e911f78dff3225ca41768ab9ea44c99854f8c34baa8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "868ff2416cf589e55963163d173f2b30515350a114b0dc70183f6b0183c62191"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
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
