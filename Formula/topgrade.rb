class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v0.18.0.tar.gz"
  sha256 "c72cefd01d2bad53ba48fabef8c0920813bac810920426f3de08d776dfbd7dbe"

  bottle do
    sha256 "712a55dca166c5139d61db721235616cae56bc9103227c9c44e14b563670f743" => :mojave
    sha256 "6b7e53e7aa13e504bfd802b1fd3ef98af818253c8fd49445ea82b4456e079bda" => :high_sierra
    sha256 "f54cdecbd3b524c1a8806c0f8db65716498b45fc540048b86afbc726de24739f" => :sierra
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
