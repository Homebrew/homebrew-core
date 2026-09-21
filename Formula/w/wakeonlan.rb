class Wakeonlan < Formula
  desc "Sends magic packets to wake up network-devices"
  homepage "https://github.com/jpoliv/wakeonlan"
  url "https://github.com/jpoliv/wakeonlan/archive/refs/tags/v0.50.tar.gz"
  sha256 "cbbf9d75db0cc0b8deb9d43ae0b0a320864bc6f00e032771f11a926b0aa2463f"
  license "Artistic-1.0-Perl"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8b61b7acecad943d4a65502db27f0761c10b974930234b7750e36f868ecacf4"
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
