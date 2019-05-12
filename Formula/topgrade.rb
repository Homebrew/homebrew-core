class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.11.0.tar.gz"
  sha256 "597631089206864a8974a71f3966fbb49577009cdcf76e2323c75992b5a5e5ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9d220cdd8a4c354c6ab765020bfdb236e834ee7edfdedfd0f4a0aca7e9d3a06" => :mojave
    sha256 "239a4b888f6fd0c62993de594b430af65c3a86084f1d06ad3aac254ac3677ddc" => :high_sierra
    sha256 "4fcb7bd6b80256d6b16c6bb234417fc469a117bd6e95d2f1d75b4e390fb3e4e4" => :sierra
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
