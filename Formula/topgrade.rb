class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.0.0.tar.gz"
  sha256 "34f4f5a037b54470da5067bb7be085f042fc1987d196f40faf8707fc2d4f8051"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc2c823897ad0d8b1e8f0e8fa601df10d9f9694102c1955338c24b58d2c6e478" => :mojave
    sha256 "baa4b766fd436837473cac4d14fad3a1015fdf9648cd154c6e4a34155bff216c" => :high_sierra
    sha256 "dd538ed9507c5f1a2373b28a259d2a8006929724e4c3a0829c62df263df28f2e" => :sierra
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
