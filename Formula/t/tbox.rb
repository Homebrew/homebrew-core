class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://github.com/tboox/tbox"
  url "https://github.com/tboox/tbox/archive/refs/tags/v1.7.9.tar.gz"
  sha256 "8d4bba88bb279c4ff71677d15f8bfc20dfbdc3b4eee27b540fb979fe5af65e56"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a0067831ab388cc5fc99ff9c152437a579a85297d25e70f93cded7fbe130af5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dbbf045ecb2a8958efa18ab791198bd9065992986c65fd85cc5e91d6f47199c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30146fc27beaa177788147cde0e0e7ae67bf808c63caf87330f574336a826d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa1be6dd50a08ee5e5975cd44ccbce1ffb73816def52325342c68a837ad179eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2a8f5671d17aa9e7a8ffbdce4f3838c2f97b7e3d8ced4aaf9349294024d55f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53f1e814d9e023789e45c61ab45224a26f15899c6059ea95f7ffbcc6a6f6c566"
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
