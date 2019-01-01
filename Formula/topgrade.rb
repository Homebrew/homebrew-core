class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.4.0.tar.gz"
  sha256 "c73f2b4c9e3bcbe8e0eb16cc5ea80af4678616ecd1c90535575ea54eb66bf43f"

  bottle do
    cellar :any_skip_relocation
    sha256 "886e8eaf161f428d5654f6f3108d958778335fa3c0e6cb1e62bace031ed5765e" => :mojave
    sha256 "8d3a8cd4e06eeb3dfe87419ae165e9977fdf5cbf58c2fb12e8d28f32dae2925d" => :high_sierra
    sha256 "9c266c0984e1909696696d4a02a115e0511d9ba9daadd99d998abf2d19c136df" => :sierra
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
