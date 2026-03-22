class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://github.com/tboox/tbox"
  url "https://github.com/tboox/tbox/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "3b919f61055b75fe9cb3796477468f6fe7524801d429e6ac48933ddde9caafbd"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2e54884a4e796cfcf80f0626c4709cfb2457a7f55322620087960dd3898dc43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "191ed24e6b0df03c2f5d2de83f4fbae1f3471ef00ebd52e4fcad6cc8d49716e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78bc0408e71342dfbdd429ff61b6958bafb01dcb2fd243a29b52a5a1337e04d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d43414168d16c5dcc7b64f140cc6a6bdc1dff6284e6115267aea03d7a5982192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "988c17883fa3616f79372ae9e8856ca03249c33a8feee0ccbcfceedcc3d33c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cfd614c4c971f8b922e37ae936cb23625adc02c47c4f570587a5274ee357e26"
  end

  depends_on "xmake" => :build

  # Fix an error for misleading indentation in wcscat.c
  # PR ref: https://github.com/tboox/tbox/pull/309
  patch do
    url "https://github.com/tboox/tbox/commit/057b9247239ec930bb3b742b2c0ec96aec95fdc8.patch?full_index=1"
    sha256 "d1384e7a285751777a73a24f1ca8de09bd1ff77f5e39049db6e6103220b3ae35"
  end

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
