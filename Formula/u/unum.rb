class Unum < Formula
  desc "Interconvert numbers, Unicode, and HTML/XHTML entities"
  homepage "https://www.fourmilab.ch/webtools/unum/"
  url "https://www.fourmilab.ch/webtools/unum/prior-releases/3.6-15.1.0/unum.tar.gz"
  version "3.6-15.1.0"
  sha256 "9e4cb91aff389091f8c04122107ce3f7face4389ee27a9fb398b574dda20b457"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://www.fourmilab.ch/webtools/unum/prior-releases/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    manifest_sha256 "36580db80bfb52c4fc97f91e77187d150e4b09664c49c2d76043b6873f7d8d0e"
    sha256 cellar: :any_skip_relocation, all: "49e6e959912529d4da9b0097beac4bcc654679022720b74eff4c5010d5ae6c77"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  deny_network_access!

  def install
    system "#{formula_opt_bin("pod2man")}/pod2man", "unum.pl", "unum.1"
    bin.install "unum.pl" => "unum"
    man1.install "unum.1"
  end

  test do
    assert_match "LATIN SMALL LETTER X", shell_output("#{bin}/unum x").strip
  end
end
