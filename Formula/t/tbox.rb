class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.7.4.tar.gz"
  sha256 "c2eb29ad0cab15b851ab54cea6ae99555222a337a0f83340ae820b4a6e76a10c"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62ebb24dc724b7f3dba2c8262ba1ab5bf226caf6920223719e73102bfe61e873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc5826b5d50388fcd27c47f7d24b03f2cc9b76d6bc05157f329844cc4336df6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fda8ab8fc03a875e824aaa5993d3f16ec790b82ab09dc4c987549a5416b5c887"
    sha256 cellar: :any_skip_relocation, ventura:        "5bbf7c0031e08716dc41c7a4a17d8e67498b213ad8556c15d383f3ea3ef7421a"
    sha256 cellar: :any_skip_relocation, monterey:       "ed7db509f9251ebd6cf983ed840a72192213b2ea610211da7c3699d239d47eb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0eeb6cdc6ad63e9e6e5a6441d77600182c9fa4f5a72271936b79ec38158a028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2412788a8bb0123e5e342ae659f495d53347e15863068ecc41a2a9fdf76cad86"
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
