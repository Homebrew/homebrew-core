class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.0.0.tar.gz"
  sha256 "34f4f5a037b54470da5067bb7be085f042fc1987d196f40faf8707fc2d4f8051"

  bottle do
    cellar :any_skip_relocation
    sha256 "6eac805f435f22435756ae83a2d924308000e643ed6da3f909b2c0a1645f4526" => :mojave
    sha256 "873c09768905a4e14b4aff55f553fcace377184ef79ae3166600011456700743" => :high_sierra
    sha256 "0fd3aff7e36ef7b0dea1262159c02e86490366f653a1d7be0dafb09bdf179b72" => :sierra
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
