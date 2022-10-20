class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.7.1.tar.gz"
  sha256 "236493a71ffc9d07111e906fc2630893b88d32c0a5fbb53cd94211f031bd65a1"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6f13d78f3d4ca21e19ccf13c2d4ee958dc81e89c59c6642e5950edafd9adc6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df134d4fba56d98b0d7246031d4f50079b9b4f407123d060a0e57de0145f5de1"
    sha256 cellar: :any_skip_relocation, monterey:       "9f862757ce2b77da94a44963b4b5c09bfb70f21b4e2e9b97a507918cbf5f8b0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "45dbbde8befcd4cd820cc20c8d858336f88df268634d103df1439150fb0dd2b4"
    sha256 cellar: :any_skip_relocation, catalina:       "8ee1efa1e17a67719e5293e019099f05663e7dd8c6a60a35353e066ec691950f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f3a38dc4a28f95e740f632ead12cdd932c45d6a32faad6d118b7c9a8cdbf1e"
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
    system "xmake"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltbox", "-lm", "-pthread", "-o", "test"
    assert_equal "hello tbox!\n", shell_output("./test")
  end
end
