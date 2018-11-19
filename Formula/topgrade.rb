class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.0.1.tar.gz"
  sha256 "e3551da7763e7219217a695a3445855d634e1428737c8a01a6e5832d31a7fc8d"

  bottle do
    sha256 "2e73cb2b3c9c4e1dc1ba1f13b474c34feb1023e235d295265cc7072d957715cb" => :mojave
    sha256 "846bd8d821a9a6eeed420e56643fb22562adc201de82386e8906712ff46a2c53" => :high_sierra
    sha256 "e380d84dfda977992c207d5d16d15dcf6f955fe77f9faa9b220751134e8321be" => :sierra
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
