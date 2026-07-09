class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.top"
  url "https://github.com/tboox/tbox/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "48284c1f1f6e4e74ce1b4d2447c3141fdfdd3a20ef1cb30fc2f1021149227fdb"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76d061f73e5c0e6d8fbe401d26d4bf576ca6aeae93e6e2b97f370e2d2e407dab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25557d6963b7ff839c52d0f250a92614395b250f181709230d423db9c579e6b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3433e15f37b902c73b339fb643fbd1ac46090cc6fd73f2000006a4806d9b8256"
    sha256 cellar: :any_skip_relocation, sonoma:        "b95716c0b5bb31a47698a8b699e4ff9da08771c69ed7f69d2b29d544cf69f777"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "247826dab771f81df3f8549d614dc06c045bea8cd452135cbdfa8dae44e74042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0899a7ca95527b78519904ff6e7804a07ef91471f3a70530235609de1db2b851"
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
    system "xmake"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<~C
      #include <tbox/tbox.h>
      int main()
      {
        if (tb_init(tb_null, tb_null))
        {
          tb_trace_i("hello tbox!");
          tb_exit();
        }
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltbox", "-lm", "-pthread", "-o", "test"
    assert_equal "hello tbox!\n", shell_output("./test")
  end
end
