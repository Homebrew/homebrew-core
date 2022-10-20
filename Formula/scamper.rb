class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211212c.tar.gz"
  sha256 "c04417aaf7eed717b88b49b7174bb5fb3a6e33da8f989523d110b3f6f37ff8c3"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "21d9f1cdc409fd503caaa4fe61265e6db6a16c487194de7debaa6c337aa6cd88"
    sha256 cellar: :any,                 arm64_big_sur:  "e2fe2c53ad383983ac3efa9966f03fa70b0366bf219064d5576e50145ad9a92d"
    sha256 cellar: :any,                 monterey:       "02b00518aebed2573109ce57b58e1d3e1d726f146a39f5d2778a54ec9ec0d588"
    sha256 cellar: :any,                 big_sur:        "ff8545179616391ae01b107678ced5d505a9a25683501dad9763b5f4b1e31659"
    sha256 cellar: :any,                 catalina:       "c3724ae4adb3ac12ccccde159aa5b7c1d097e8a9395c3ce1c9515a86fcce3aa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7ebac291f25cb739cfa7c220032d2fffadd42511bee72d5762932be1140e97"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
