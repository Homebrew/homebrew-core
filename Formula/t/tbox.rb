class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "6382cf7d6110cbe6f29e8346d0e4eb078dd2cbf7e62913b96065848e351eb15e"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0cba603567a21c953c379d310ef4e739ab85e89166ee9ca0820e6de954377c97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2142d282316e44304970e782ded4fd7e0a8452e6ad73d0a6cf1b9a0545ec531b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "692c95557e62dda6982466fbe66a22d7ed64549f2c158d928a520c8a0ea3fedb"
    sha256 cellar: :any_skip_relocation, sonoma:         "772cb2e215b8aba72180a7703bc94bd42514e65f79abb16f6c29d57f038c26fb"
    sha256 cellar: :any_skip_relocation, ventura:        "cefd8cdb4944f9559e7e36b29b2b544fd993ef5e9b3923ab077625bbd65fe4f0"
    sha256 cellar: :any_skip_relocation, monterey:       "7232c7cb489e7cf1a66375b4cabf4697c4ab1824835ed051b0fd5d067bdbcc65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e69718b923819a194a1fba1efdfd0393602ea4048da27f5d519a09e02d4158"
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
