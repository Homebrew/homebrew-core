class Unum < Formula
  desc "Interconvert numbers, Unicode, and HTML/XHTML entities"
  homepage "https://www.fourmilab.ch/webtools/unum/"
  url "https://www.fourmilab.ch/webtools/unum/prior-releases/3.3/unum.tar.gz"
  sha256 "544dd1172665c38237bbeb2d4d820329064e6a78373486b92fbd498714dc2e91"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://www.fourmilab.ch/webtools/unum/prior-releases/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e0f619918472df38d68814008a4a39238faa5b6dcc7b259486491c96da869f17"
    sha256 cellar: :any_skip_relocation, big_sur:       "668661702317b0eda68f6e710916536f96c0a459c9500c0ac684359b2a8657b6"
    sha256 cellar: :any_skip_relocation, catalina:      "7ceee0d5f8227329b325fdbabd54b7c2cd6a1a5ad38a3ab8b860c25036197fcd"
    sha256 cellar: :any_skip_relocation, mojave:        "7ceee0d5f8227329b325fdbabd54b7c2cd6a1a5ad38a3ab8b860c25036197fcd"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  def install
    system "#{Formula["pod2man"].opt_bin}/pod2man", "unum.pl", "unum.1"
    bin.install "unum.pl" => "unum"
    man1.install "unum.1"
  end

  test do
    assert_match "LATIN SMALL LETTER X", shell_output("unum x").strip
  end
end
