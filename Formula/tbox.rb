class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.6.9.tar.gz"
  sha256 "31db6cc51af7db76ad5b5da88356982b1e0f1e624c466c749646dd203b68adae"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad121f69e2c9c818fcce62bfb477017ed1d1d47352f257842ff385368ad66c7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f0c03016b30bd27603a1e6b10eeff077fc1437d80ca1f6f828715a129a183fb"
    sha256 cellar: :any_skip_relocation, monterey:       "896de58b8fe02cc9ac808d6a3e569dd4b5a5649c6a43b6f9164b4c86617b032c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed28f33c4dd5f7e15596a641de2f3175a8af11d529fd31e146d01bb4a733696e"
    sha256 cellar: :any_skip_relocation, catalina:       "2050132144784c9dcb2080499d1961ccba6d0555ac3b823bc9dd4348fc80991e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd483cc00fc3484da59c334413386fb7e29ef6db05f6f98b5f152c458eaa29d7"
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
