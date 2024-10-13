class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/refs/tags/v1.7.6.tar.gz"
  sha256 "2622de5473b8f2e94b800b86ff6ef4a535bc138c61c940c3ab84737bb94a126a"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7947e45eec0391b3732ef28f7ef9fb0649eccee820613ed780cce5c80101a27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6916f2df0cd8419ce91cabc711cdd273d2dde6efbc6ed3b9ca9e71c7d0eae20f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dcdc2a92ff3cb0f2c8e4a05285f959fda6398b1862f5ec53114428dd13582560"
    sha256 cellar: :any_skip_relocation, sonoma:        "70c1474ce62ec18b5a1b74e11a4ba24a4297231a6a142122880fcf30a331610e"
    sha256 cellar: :any_skip_relocation, ventura:       "c88d154bbacefc84abe1e820ef715776da57469d8fd4016c25ef3c71ec17a129"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f219b5aba807212ce3b30463312c73d287031ce5f064e5f0b5f2006752cd2e"
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
