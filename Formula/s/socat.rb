class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "https://distfiles.alpinelinux.org/distfiles/edge/socat-1.8.1.1.tar.gz"
  mirror "http://www.dest-unreach.org/socat/download/socat-1.8.1.1.tar.gz"
  sha256 "f68b602c80e94b4b7498d74ec408785536fe33534b39467977a82ab2f7f01ddb"
  license "GPL-2.0-only"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac0c47bcebd304502db55e0a67b3fbca2af8b882c331f6f238f00f543c997ea6"
    sha256 cellar: :any,                 arm64_sequoia: "34e3d8eabea5928b3f37d589b32d118c5aa47e3aef264da0d8b2470e3eb81787"
    sha256 cellar: :any,                 arm64_sonoma:  "97441f063428c38f4313079e8bafc4ea2835b9c93a9f757ed3d7d022acd46f2d"
    sha256 cellar: :any,                 sonoma:        "00617f292b2d5e3887321fead711ee7a7de79b773829027f872f66e898ce4bb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8516bb17bc2e9ff8382a3038ec2ad58c2d2198224cbc1601e0086adeb5bed764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f5785c495d7e676ca4b2c34d16ad61363fb3c7efd5f2f7e2cc5e7bb1e413fa5"
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
