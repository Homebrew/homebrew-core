class Tcpsplit < Formula
  desc "Break a packet trace into some number of sub-traces"
  homepage "https://www.icir.org/mallman/software/tcpsplit/"
  url "https://www.icir.org/mallman/software/tcpsplit/tcpsplit-0.3.tar.gz"
  sha256 "9ba0a12d294fa4ccc8cad8d9662126f01b436ced48642c3fb2520121943f5cf5"
  # The license is similar to X11 but with a different phrasing to the no advertising clause
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/href=.*?tcpsplit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b02564f0e125bdab2ac132ffdf03a9c621fc26a1ec3182a27e4deca418f29b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b13d6af21036479f6a802039f11fc02a16a1d1cbda789af99ecba3100d88130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a6891aac6306a346be1a28c7ee462636576a7835c8e7a796d6a3d64cd5ceb7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "415a55da3fec588f476a348a4d5424ab7fa2a4bfdbdfb30e8e5d7a225f1bee56"
    sha256 cellar: :any_skip_relocation, sonoma:        "098840d4bbc97133040b4697034b972fc24acaeb6175bee7da477c495df5c5c7"
    sha256 cellar: :any_skip_relocation, ventura:       "9cf285c0719876d2dbd4df148886919cdec7d0b51bc8e59bc0feeffe733cab87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b4ad04b2a151de072a19e191e56b996008f105147feda5b7bc449430f7327c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8f207776a5ace12166e89d26b391cb43a7bf4c289d620b49ea4c948d1d91e9"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    bin.install "tcpsplit"
  end

  test do
    system bin/"tcpsplit", "--version"
  end
end
