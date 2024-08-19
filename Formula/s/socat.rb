class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.8.0.0.tar.gz"
  sha256 "6010f4f311e5ebe0e63c77f78613d264253680006ac8979f52b0711a9a231e82"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ff5c098db313f3df10b6f5cecef409b260ecb9b9103e7326699053f0094d1b6c"
    sha256 cellar: :any,                 arm64_ventura:  "1d173fedbbbff9af5bc3a794d0faed5ef703fc219ccf8d66cb196486d550276d"
    sha256 cellar: :any,                 arm64_monterey: "37643b2b32b6aede3a7002a63d25002ea939778b318692f87db48fb85f21948f"
    sha256 cellar: :any,                 sonoma:         "39f37b1b1798d765a4e156a7ad41937c8f3cc67c4a6b9e7ae445b632d60ae1c4"
    sha256 cellar: :any,                 ventura:        "fc0b566014714676a99fcbc63acb65493d5cb569e22e17d4b51de203cc44fc2f"
    sha256 cellar: :any,                 monterey:       "e5b1ceb2803cc892aea2d4baef9367d86a53bf104199f57a2763fd92041ccf2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6015a9c04bef57893a367772f86625873b591e27ccdd0f9d9f66f7a5f8bc5ac8"
  end

  depends_on "openssl@3"
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
