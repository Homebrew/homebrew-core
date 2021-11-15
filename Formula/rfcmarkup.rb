class Rfcmarkup < Formula
  desc "Add HTML markup and links to internet-drafts and RFCs"
  homepage "https://tools.ietf.org/tools/rfcmarkup/"
  url "https://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.129.tgz"
  sha256 "369d1b1e6ed27930150b7b0e51a5fc4e068a8980c59924abc0ece10758c6cfd7"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(%r{>\s*Version:\s*</i>\s*v?(\d+(?:\.\d+)+)}im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d97d7f0dd108bd9402c9bb0a22532f1f4f16dd8ebdd2004d865ced971d899ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d97d7f0dd108bd9402c9bb0a22532f1f4f16dd8ebdd2004d865ced971d899ad"
    sha256 cellar: :any_skip_relocation, monterey:       "993672e2e414a95a06259ac6960d37ac9cf324093766fbf28adf3579fd450678"
    sha256 cellar: :any_skip_relocation, big_sur:        "993672e2e414a95a06259ac6960d37ac9cf324093766fbf28adf3579fd450678"
    sha256 cellar: :any_skip_relocation, catalina:       "993672e2e414a95a06259ac6960d37ac9cf324093766fbf28adf3579fd450678"
    sha256 cellar: :any_skip_relocation, mojave:         "993672e2e414a95a06259ac6960d37ac9cf324093766fbf28adf3579fd450678"
  end

  depends_on :macos # Due to Python 2

  def install
    bin.install "rfcmarkup"
  end

  test do
    system bin/"rfcmarkup", "--help"
  end
end
