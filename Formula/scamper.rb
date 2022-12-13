class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211212e.tar.gz"
  sha256 "6da7064a08a16671a160baea926d0d304c38a441549a7c0dd7d0abf2e5e7a5f7"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "63d99c6aa9b30f936af643dca14079b24355646688cd89285ca25fe1345d56e1"
    sha256 cellar: :any,                 arm64_monterey: "e317efabbf1911d3643f93033840e33ea89240a601a66df500f7bf596348897a"
    sha256 cellar: :any,                 arm64_big_sur:  "a5f17ff4eb9cdaa93ae35651d6b9f1b3bdd3f9000bebf76022881a7bc30cef4b"
    sha256 cellar: :any,                 ventura:        "0b24a77710c2b63bf995d7627f7646c4fccc94f749eaf1b8f8c570616c998038"
    sha256 cellar: :any,                 monterey:       "b7e3d80cee61ef67956527f85825079cb3f77b163ce37be46bc09f97d669cea0"
    sha256 cellar: :any,                 big_sur:        "d7df9ba49aed51d02c7a5b333085453d3b2863538d760f94b480b57ba86af8b9"
    sha256 cellar: :any,                 catalina:       "72268d5b38bb2636c65054efc42b6c8f7eef0ab5f60519dce73e5b1c93d2140f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9f9783386bc0d09847c6c2105f6385b0b40671b219b16364224ed9f07aae8a9"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
