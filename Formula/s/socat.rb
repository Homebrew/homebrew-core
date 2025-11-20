class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.8.0.3.tar.gz"
  sha256 "a9f9eb6cfb9aa6b1b4b8fe260edbac3f2c743f294db1e362b932eb3feca37ba4"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f7e7d5260c272cbd1e7fa756d05a754fc4622d0e7186b10cd9f1844752c098e0"
    sha256 cellar: :any,                 arm64_sequoia: "4d18220d65718e33cfb0df17d6355363e631a92743de11b62e8f35c031229a45"
    sha256 cellar: :any,                 arm64_sonoma:  "590558b903c048f2b1470448332db9e614dfb957bc88792a2d6997cd6b25bbe3"
    sha256 cellar: :any,                 sonoma:        "9a11d44ff176f147b77ad3cdbc61288572f59439b522424d498a7f189cf90fbd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b1267cd58832bc2baf9411126edd297f26ce63d87e6190e431e7908e7f6c08d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5509b742cabf4d42fdb8af7777a32eb6ec2771e1af5b7087a34e7b5937c7f5"
  end

  depends_on "openssl@3"

  def install
    # NOTE: readline must be disabled as the license is incompatible with GPL-2.0-only,
    # https://www.gnu.org/licenses/gpl-faq.html#AllCompatibility
    system "./configure", "--disable-readline", *std_configure_args
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end
