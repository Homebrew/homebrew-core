class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "https://distfiles.alpinelinux.org/distfiles/edge/socat-1.8.1.3.tar.gz"
  mirror "http://www.dest-unreach.org/socat/download/socat-1.8.1.3.tar.gz"
  sha256 "06602ffd591e98c75b3dc1d66f0f19136cc666b0b2d95caad987d6ab2cb28097"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0b4a8646ec47193f827860cd0c2254b18e96bfaa88fa08fcffc9a08394d6ba81"
    sha256 cellar: :any, arm64_sequoia: "7d6705023258039de58e71b4eae4343443dcc47ce151c25385f90542c24588be"
    sha256 cellar: :any, arm64_sonoma:  "b9e5c820a3038987f99e4381c30473ae915a9d0039bc706bc29ebd4089ab837e"
    sha256 cellar: :any, sonoma:        "918748776fd6d2be50f4982251544048a6e64f9e3c13b577f35530a14077c40f"
    sha256 cellar: :any, arm64_linux:   "e3587d33ea8c68ad45babcfcb4b15ec291345d3c9eb4138dd807449722822474"
    sha256 cellar: :any, x86_64_linux:  "70e101e17362a4f49ea45c3bc72ddb05f90b04824b3ae7ce5fec08de758a9e45"
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
