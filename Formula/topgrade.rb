class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.8.0.tar.gz"
  sha256 "a1c125ddf5f43ecb1c53a7a4b8853f6b31cdf193cf4d4f64070ee224089c8ed2"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fe2ea6ac947ffbb486f574b71df5882858739a4104224bc485b2976e43410ee" => :mojave
    sha256 "f0b35508bd2e22779045c5c2d4c4a58de677234cb5b09bd598bd48fef7651159" => :high_sierra
    sha256 "b8a72adcaf4be87f90e28354619ba3ee1d20de2c69518f483cae46cec5283c04" => :sierra
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
