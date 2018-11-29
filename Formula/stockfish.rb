class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/files/2629649/sf_10.zip"
  sha256 "9c2aa8b06935c930e80cba1426e10d76b6b1accc5a769e6bf1f41e15d79cadda"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a7bfc50e3113904fecffe1e49a156ce2cfe26907976dc0c5a02af7e6ee7be57" => :mojave
    sha256 "3ff96f059490975ffa143348bff41769913fe39d5c813c792feae4d1c308c179" => :high_sierra
    sha256 "906cebac002d1eed58e56d331d159e4629e198600757321c3c7bfebc4fbd6c50" => :sierra
    sha256 "9a95bbc0f2fd8274c9109524c24a88de7546ff6529c80fcf8a545f6151c53ba2" => :el_capitan
  end

  def install
    if Hardware::CPU.features.include? :popcnt
      arch = "x86-64-modern"
    else
      arch = Hardware::CPU.ppc? ? "ppc" : "x86"
      arch += "-" + (MacOS.prefer_64_bit? ? "64" : "32")
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
