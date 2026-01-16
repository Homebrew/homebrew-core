class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "https://distfiles.alpinelinux.org/distfiles/edge/socat-1.8.1.0.tar.gz"
  mirror "http://www.dest-unreach.org/socat/download/socat-1.8.1.0.tar.gz"
  sha256 "9a884880b1b00dfb2ffc6959197b1554b200af731018174cd048115dc28ef239"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "91543aa167477e8c387300658044d1bbe468f0be8e7163d4a5fa67c5f09e71a6"
    sha256 cellar: :any,                 arm64_sequoia: "970538b7e516f15ebd996bb334fe6055a128274ad02670d73a39900f7dba4b7b"
    sha256 cellar: :any,                 arm64_sonoma:  "4941aaa2611794ba979e67afa19627255574616331323073a153ccd0423e88a2"
    sha256 cellar: :any,                 sonoma:        "89308a55b06e28349010a85de1d0951d31f2b3053c19d90af8d0811b43238609"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fd2104b6d8ceb9c5434de09a4d9ce4e1f3431439f5d8ac4c8429c6356c10a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b6e1c2042c826eb23d6c9c705db3d48325723e184bc20e233f384e52d0b5cd"
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
