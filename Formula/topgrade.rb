class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.5.0.tar.gz"
  sha256 "08ed535514b283c811eb093e51dbce4988735072a8511f0ec3019e43a242c58f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f600f8acc2ead4e8aa630780e80f36edc7a5a69719f7fd98f48e4410613dd9f" => :mojave
    sha256 "e48af38600fe09e3b65f2193a9ea51aea309c49527fc8e861313771fe3b600f0" => :high_sierra
    sha256 "b80c9abb8fcd632c80dfc95e88e157cf2d32c37daa3a6d87d4e675cc07fffd30" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
