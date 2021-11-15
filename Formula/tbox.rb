class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.6.7.tar.gz"
  sha256 "7bedfc46036f0bb99d4d81b5a344fa8c24ada2372029b6cbe0c2c475469b2b70"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89d842123d7f547042298dde6663d5a4a8c6731d1ae02e714c88c1628910b63f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ffdb8f21d12d57dad00390ecbf0bc3cd7872e3de08c50466f6fdcd6e8c1700e"
    sha256 cellar: :any_skip_relocation, monterey:       "a07d5346d050123b7dcb00bdc11b5e4295dd957a8a05911b6370aac6f8d3214c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b183ed255da7495acc08c672aa3bbb8196aa66e237f2334a6131def4cb137f8"
    sha256 cellar: :any_skip_relocation, catalina:       "19fc7b975473de7c23c5f726a36fe7ceb11b2b0dffa6a978619a5fafb5f0f31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08666405afaf5b23af6184050f018a2346e75a2f20cc77477a3af5343c2c5126"
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
