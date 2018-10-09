class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v0.16.0.tar.gz"
  sha256 "5cb12fd944a26da71581c78e19b320c056b8ad9cf0f867f4b1c352a1bc3eccc1"

  bottle do
    sha256 "b71341a085ac93dda023c1cf4eb4475950fb5da3a49ec554c3579d668ea3b029" => :mojave
    sha256 "609a19975e9a4d67035aa1814f73bcfa1a9cb66232eecbb343dda526c9a20d31" => :high_sierra
    sha256 "526ef20dcba2fe9b0ea69a2fec3537e874629358132e5424370a185d40fca1ed" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
  end
end
