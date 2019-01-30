class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.6.0.tar.gz"
  sha256 "e911e58f999c7b1d34e5b68582c748238b1594b822cc0e566feaa1f99e1e53fe"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1d359d8b54bfccd16cbaace479feae9e0413cd04b3ef37f3a9c17c8df385a0d" => :mojave
    sha256 "06adf197e6b025472ed2d32644a4eec62def0e9c79049b3509b576fe29ebc050" => :high_sierra
    sha256 "d17c4e25a3b312b3e2fe014ed2ad981e286b8ad707184f571c35734fdc606079" => :sierra
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
