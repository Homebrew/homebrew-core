class RsCube < Formula
  desc "Blazingly fast 3D ASCII Rubik's Cube"
  homepage "https://github.com/doprz/rs-cube"
  url "https://github.com/doprz/rs-cube/archive/v1.0.1.tar.gz"
  sha256 "006d2e96e12a066ba1f4fd74a8dd07f0e4b75437836cc5cbf3900adc74de607c"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rs-cube", "--version"
  end
end
