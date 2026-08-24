class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.top"
  url "https://github.com/tboox/tbox/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "8601bd1443ad3e3eb998406a71c3896f8563ed1aeb94a9ccf8c17543742d508e"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b6c95551a1db5b83f9d6536cee1c12f530f32779c905a5685fd0d17d797c46a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64851334ab38636d05e48384bcf87a8dc0dae0b9314dbab02ef7dced5978d4ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "567efe598f87c57a5841c03a62ea850efedac799a0b2ba398fda9bb00ee4d13a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd9a4b2fbf4a4aaebcaeae4bff515f4967377d5bd1251d9c8552f095430f3ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "229340c927f6392b6bcbc029c3b84b48c0a37f65ef1c602b292ec0bb7f987c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae1057799d9c46b2a8bb5074ce94453f02a41e61aac512e9cf81ebfa3f1a1aa3"
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y",
           "--cflags=-Wno-error=misleading-indentation"
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
