class Tio < Formula
  desc "Simple TTY terminal I/O application"
  homepage "https://tio.github.io"
  url "https://github.com/tio/tio/releases/download/v1.32/tio-1.32.tar.xz"
  sha256 "a8f5ed6994cacb96780baa416b19e5a6d7d67e8c162a8ea4fd9eccd64984ae44"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "257626785fcbbab8298a98f912c7831b1c9565536ff6425c438424fca3163d90" => :big_sur
    sha256 "cd68cb38333ea9bf99d8e0cdd28cf73ce8517b834213b2f786f29c4d58ca0dd8" => :arm64_big_sur
    sha256 "a630b860983adbd4c2691538739850ef934aeafcfa33c5561a00e3db2b355e88" => :catalina
    sha256 "f33b4bc0d653c0f2111f0c30865395d2cadfe524f33ab1c84c843e54ec432ed9" => :mojave
    sha256 "1241b11c102b527fd43225a3283290fe5488889a9e0919e7b4b536ddcb4a4d83" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-bash-completion-dir=#{bash_completion}"
    system "make", "install"
  end

  test do
    # Test that tio emits the correct error output when run with an argument that is not a tty.
    # Use `script` to run tio with its stdio attached to a PTY, otherwise it will complain about that instead.
    assert_match /Error: Not a tty device/, shell_output("script -q /dev/null #{bin}/tio /dev/null", 1).strip
  end
end
