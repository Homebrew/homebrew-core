class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://github.com/tboox/tbox"
  url "https://github.com/tboox/tbox/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "ae387dcf1952aca572516bdce4a47d04e9b411f5bf7add281247af7c874f3c3f"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0157e36f3c03a6cdaf4e17b60320650aed9d99398404ca6d894c714f0b44631"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e4af286a06c7866122031814f6a626582ab9547e98e475ab98eaf6ea86189f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71ed8833a338308bf58f3be6ee12841e046a381cae5850a54c5ea8b863f8c28d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9711d7ffe9e3d9aff25a4fe4fcd8c00561abafce8165dbd12a74278c3eafa82a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3efecca9ec4ddd248669af677d411d92f4492614f21c3369f6b34bf4ecb7b446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9ac90346db19743ecd7dc455f60b18c8dda35bb4d3be669811112be1b515f31"
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
