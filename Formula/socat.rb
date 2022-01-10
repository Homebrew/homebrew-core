class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.4.3.tar.gz"
  sha256 "d697245144731423ddbbceacabbd29447089ea223e9a439b28f9ff90d0dd216e"
  license "GPL-2.0"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bebff01d4a9da5539be0c56064458506ef3c2e098e66e3ecdd81a56b953b18bc"
    sha256 cellar: :any,                 arm64_big_sur:  "ab41a0fff966fe7d766604de9392c18fb5fb1bbe938fcb13ed2861ba9d7e65bb"
    sha256 cellar: :any,                 monterey:       "7de63a881d222435b6ea2f416a93f758f265feb87573b2bd8045b6fc383196ee"
    sha256 cellar: :any,                 big_sur:        "4ee020dff0b50603598022a6d924fffdf105fd175772fbbd84efdd52397ac023"
    sha256 cellar: :any,                 catalina:       "e45f83eee32c323aca752b3a63075b8d65b4eff1814bcce3cd5fdd01c7a526f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1932cc4004c5f6234de385b59e36ce686d6e7e152526d9b47dd9fd9bfd13c4"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
