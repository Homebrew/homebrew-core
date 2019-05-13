class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.11.1.tar.gz"
  sha256 "81caf3a339942a7e029a6d5be32e693ee9e5545ef0eed48234cc6a6cc3c52095"

  bottle do
    cellar :any_skip_relocation
    sha256 "61c8c25714663be088123ae99dd1d1f0131f947effc292e0d693737b99f19ec8" => :mojave
    sha256 "3acc9c52e4f87cdaf4e6507e7934a314e622847dec81e6a09ec0e642e3a7a603" => :high_sierra
    sha256 "6e078da39ef6dc860ded112cfabe1ef12031d76715b2c39210329d5ad048fd3e" => :sierra
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
