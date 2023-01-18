class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.7.3.tar.gz"
  sha256 "1d8dea39d39d67b729098e1e7b31de2aa54db67afee6087064f049d60146a49e"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "672d3b2ca57b0e9513f5467e1be1c8108b2256a1c9294c4d4dace9aea1c9303c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab614ce23f86d3b2a3e40bede779007934f87ee378ab2e6a676682bddd4b487"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "639773c80eed44b1e905ad48f2d6d2f09c22f7380927ac3d11a277445f2efa9f"
    sha256 cellar: :any_skip_relocation, ventura:        "f5d4d0ca087ed4f0b6f6f086171e9c8d6250b4c0518c281be9855dbe86a0df44"
    sha256 cellar: :any_skip_relocation, monterey:       "6b314b66ce86d02215eba26bdabfd9d0b5bfcc9a1cc16d2c53ea92fe35c99c2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a4d9f8dc1b50151b139c3f17a857e558d43e94f35085c2d809153e4d222c266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "784747c9d18597cc3d82ddc4b7ec3e98a4740bc529c4889375f9a3eeac6d24e0"
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
