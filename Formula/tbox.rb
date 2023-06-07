class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.7.3.tar.gz"
  sha256 "1d8dea39d39d67b729098e1e7b31de2aa54db67afee6087064f049d60146a49e"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42233da1f62be7d9c6d3ab4cab1223a84e7aeb413fe184d128beb3ec85569423"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c1ae4a3ec702e3246284b593103cc59524571761e5ce96050e83f32d1f3a46e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "64979f165a647743e0f71ff3308812bf37f51092826ecdd0d84e72108f2ce052"
    sha256 cellar: :any_skip_relocation, ventura:        "2327bd47a429049fef7985ad17c55d25ceba79baca4554a56a29bd50043503bd"
    sha256 cellar: :any_skip_relocation, monterey:       "f07cc8681f5f9abd7c7d8172c5343467a96bfdd76a1acbfb38c84e04e41605a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae95c8e023cbea3df56108318903f627fee2a16d20e19eefb87c8936369bddf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2849a669989cdea8313f421951bc75ac0ce189d86beb76ef76d03e6a7654bc11"
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
