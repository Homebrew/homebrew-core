class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.6.8.tar.gz"
  sha256 "f437a31caa769a980e2e38ecc5bf37f1e572325d5d60fd242b9d6d49174b66fd"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7686e4aca03fead3b10e49568600935d7bca9678bb747d736640f4aa907a68cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af68ee72f0afb7f60bdffd342c152db700c54212500a262597625c5ac8f50a33"
    sha256 cellar: :any_skip_relocation, monterey:       "c21d7e5f3bc3a15338a0c1d6d55d72c396e1308049fe52228ef8451853870b23"
    sha256 cellar: :any_skip_relocation, big_sur:        "8acbb9ad518a7c4e82de5510af88657dd0c1feab3db55e672f96d06459c1675b"
    sha256 cellar: :any_skip_relocation, catalina:       "f1e53bfb8397d14871282edc646ef993fa0d5cfae0c1243fcac2cbbcefb61755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec1c0828078dc222ae93501f594a07d9d10945adeac23bcbf8eb04a67f403b18"
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
