class Unum < Formula
  desc "Interconvert numbers, Unicode, and HTML/XHTML entities"
  homepage "https://www.fourmilab.ch/webtools/unum/"
  url "https://www.fourmilab.ch/webtools/unum/prior-releases/3.4-14.0.0/unum.tar.gz"
  version "3.4-14.0.0"
  sha256 "23f49b6c56ce7ce94abd127e881d3c3feb26960a3101bc7778a856d251d5fa15"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]

  livecheck do
    url "https://www.fourmilab.ch/webtools/unum/prior-releases/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "640c91509e444f6171ea9d13c68e0e9ece7021fce1db564455a19fffc8c5494e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dae4e5fb5df8571910212e0a0934e2e3584734b1cea0f5072777172ba5e7ac8"
    sha256 cellar: :any_skip_relocation, monterey:       "8e68092133f021ccaf0f895980f1b4154099462334f18ee6857e5080eebf1147"
    sha256 cellar: :any_skip_relocation, big_sur:        "910eb0162ba9336980a79b739558cd2c08fb4c0a65c806550743fff7cb003282"
    sha256 cellar: :any_skip_relocation, catalina:       "2a5ab6cf669d808d6eb522cd8b75d96f481c8ef94012c583378b07a0b0e00b9e"
    sha256 cellar: :any_skip_relocation, mojave:         "2a5ab6cf669d808d6eb522cd8b75d96f481c8ef94012c583378b07a0b0e00b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6c75897ea34e9331c83a767742f6d0f90b1e0117bb5e4a396a58a74a010074"
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
