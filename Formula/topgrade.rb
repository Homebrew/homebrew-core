class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.11.0.tar.gz"
  sha256 "597631089206864a8974a71f3966fbb49577009cdcf76e2323c75992b5a5e5ac"

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
