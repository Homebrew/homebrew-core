class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.11.1.tar.gz"
  sha256 "81caf3a339942a7e029a6d5be32e693ee9e5545ef0eed48234cc6a6cc3c52095"

  bottle do
    cellar :any_skip_relocation
    sha256 "47ba88e70e371cc6c8601d42d2e6d58e5979688cd4072ce9ef22807d6c23207f" => :mojave
    sha256 "47797a272906dc84c9a1a8df3fe840cfcae3ece91d20f6a8dc3358069bb6d8f3" => :high_sierra
    sha256 "70823b0f28f128df4bb5c2c9660353d0c5a9b0bc908b94752d3e66b145d38f73" => :sierra
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
