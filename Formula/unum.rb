class Unum < Formula
  desc "Interconvert numbers, Unicode, and HTML/XHTML entities"
  homepage "https://www.fourmilab.ch/webtools/unum/"
  url "https://www.fourmilab.ch/webtools/unum/prior-releases/3.5-15.0.0/unum.tar.gz"
  version "3.5-15.0.0"
  sha256 "7723433fc5eeda0e9ea01befde15d76523792177f2325980083c270fb62043ae"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://www.fourmilab.ch/webtools/unum/prior-releases/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c22bef3d871c22b2ae47fe00da1c301a0acae08e51268a6807747fac0939b4a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c22bef3d871c22b2ae47fe00da1c301a0acae08e51268a6807747fac0939b4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd5abefdf57460ea0ebdc949267fc2b3443c71aaf2af7cb70701c8fd797b977d"
    sha256 cellar: :any_skip_relocation, ventura:        "8a80b4ff18e6259cf34baaadb8a37e773225b14bd90b2104835fab1fee239f1f"
    sha256 cellar: :any_skip_relocation, monterey:       "22e5c8640275d380cfe78193668b1c7444add4abf05b7390cbd360d1e3d37fe0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd97a83fe0f4c0bb3c1ff8966c9f116237cdd243db8b2d057454642ab67ccd18"
    sha256 cellar: :any_skip_relocation, catalina:       "81439219eeb57ab4ea2ece284592bff4bba3a55be535a6302ccd8106f56caafd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8beb082a5c05e340d3dc8606e855cae89e646cb922f9c599b2859aac39f4a8d1"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  def install
    system "#{Formula["pod2man"].opt_bin}/pod2man", "unum.pl", "unum.1"
    bin.install "unum.pl" => "unum"
    man1.install "unum.1"
  end

  test do
    assert_match "LATIN SMALL LETTER X", shell_output("#{bin}/unum x").strip
  end
end
