class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.1.0.tar.gz"
  sha256 "d4966b2acdbec7f3f8127782fb8fd1d47239cac08c54f4b4354ceef0bee6705f"

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
