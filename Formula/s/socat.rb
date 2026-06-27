class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "https://distfiles.alpinelinux.org/distfiles/edge/socat-1.8.1.2.tar.gz"
  mirror "http://www.dest-unreach.org/socat/download/socat-1.8.1.2.tar.gz"
  sha256 "daeb9eed37a99424cd14877208706e93745c91cb86fb917a355635f4df5c8499"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12d001b7ebd38e11f543fdeaca6e871db281c06504c162d4649e91a54347ce07"
    sha256 cellar: :any, arm64_sequoia: "de871e7e5581ff27cd78c214acbf5a700f54b2e812f1aad87eff6f095c3ddb68"
    sha256 cellar: :any, arm64_sonoma:  "b350e679ea7090afdfba695efcd6755e9bedc8847c7bc971429d28f7752e1dff"
    sha256 cellar: :any, sonoma:        "a1d88e0d64fb89e78a069a18778b9ab892637296243f43118ebb1c445d7b24df"
    sha256 cellar: :any, arm64_linux:   "929da32103078345a0b8c9cfbe3a53491be953d7656e93db4699641964724071"
    sha256 cellar: :any, x86_64_linux:  "b3c375fabafc8fd9f816c1976fdcee456f67ad75b6244074f09ef13b91ab269e"
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
