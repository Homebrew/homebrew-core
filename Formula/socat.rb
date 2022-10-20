class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.4.3.tar.gz"
  sha256 "d697245144731423ddbbceacabbd29447089ea223e9a439b28f9ff90d0dd216e"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6ec140eff3260a12b045bef839bf7540f7b7a0c9b708403217995f7f084e6423"
    sha256 cellar: :any,                 arm64_big_sur:  "f3e91fc6dd04e6f5402f18fcd949d883dbd48bd292e24c3861e1a9499781cf0a"
    sha256 cellar: :any,                 monterey:       "73fd0ea6e6726d59213e04a5e494107dedfab96035a86b0cd1e6393a31e1fb4a"
    sha256 cellar: :any,                 big_sur:        "ef42488ec3c32855172e0f9c37382fd1023f4217e979ca0284f87a9d5bf9237e"
    sha256 cellar: :any,                 catalina:       "cac9a7e2cd195b3b95b4698df5f261821adfd12be00fafcd2234526bad7fded6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f0c6a24f3828789152f08dc17bc86987d3301457173712137ecf0ced9c5bae6"
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
