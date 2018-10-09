class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v0.16.0.tar.gz"
  sha256 "5cb12fd944a26da71581c78e19b320c056b8ad9cf0f867f4b1c352a1bc3eccc1"

  bottle do
    sha256 "4b1250a32e4f54a08c9f8327f2440749e504e8f76b9bd3c7eb60bceb7f264774" => :mojave
    sha256 "0c43097bde30d85f0541ec370a2d61ada00de5485afbcc646c7b7dfcc34d9831" => :high_sierra
    sha256 "38d5215dacc2da6d2b13870f462c8a07c73b19277b04e35562021cbaa7bf1bb7" => :sierra
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
