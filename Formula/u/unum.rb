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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2bbbba3414c284badb1f16726092c9c2b0df15e584442b6f9a57a86b6136c7f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da2908ba84393f040c3fd859a4c1f44c9ead4a5ce06cee7dd38625065e0631bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da2908ba84393f040c3fd859a4c1f44c9ead4a5ce06cee7dd38625065e0631bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da2908ba84393f040c3fd859a4c1f44c9ead4a5ce06cee7dd38625065e0631bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "11d6646154273911dea7b648880e183aeab4a93bb6599a696c059f4dde13d98d"
    sha256 cellar: :any_skip_relocation, ventura:        "11d6646154273911dea7b648880e183aeab4a93bb6599a696c059f4dde13d98d"
    sha256 cellar: :any_skip_relocation, monterey:       "11d6646154273911dea7b648880e183aeab4a93bb6599a696c059f4dde13d98d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "24b0920ba95e6fd4bcb98186c548603f8a9e3347fcd176d8cfce6b0d70bca525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb8caefc407d78aa4c1f58392ae2b227a54ab50ed17734440cf92b1f6aa81298"
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
