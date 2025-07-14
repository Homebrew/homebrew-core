class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https://github.com/jpoliv/wakeonlan"
  url "https://github.com/jpoliv/wakeonlan/archive/refs/tags/v0.42.tar.gz"
  sha256 "4f533f109f7f4294f6452b73227e2ce4d2aa81091cf6ae1f4fa2f87bad04a031"
  license "Artistic-1.0-Perl"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0859c811ae72fce06de1a607d36b0955517c80f5ea73431ee6c1dd38c749a0c6"
  end

  # Build with Homebrew `perl` to build an `:all` bottle.
  depends_on "perl" => :build
  uses_from_macos "perl"

  def install
    system "perl", "Makefile.PL"
    system "make"
    bin.install "blib/script/wakeonlan"
    man1.install "blib/man1/wakeonlan.1"
  end

  test do
    system bin/"wakeonlan", "--version"
  end
end
