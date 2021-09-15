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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7875f9a1d69e17ee8db706b271fdf440be41a5c82ae49fb92ad978f977ee87c9"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b06d8e730fe99e43e0fa0414c4009ed321fa3f76030cb0a6d9ec51bec53eebc"
    sha256 cellar: :any_skip_relocation, catalina:      "fb174cf449a9d7442bfeecb93ef0daf07d90928e4cdddd55a66e91d4e882956a"
    sha256 cellar: :any_skip_relocation, mojave:        "fb174cf449a9d7442bfeecb93ef0daf07d90928e4cdddd55a66e91d4e882956a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcd8145ffe04375efa30266b788dbeb087bdcf90ea2f8ce5a379b8ddc8a502d9"
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
