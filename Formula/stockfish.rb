class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://stockfish.s3.amazonaws.com/stockfish-9-src.zip"
  sha256 "ba2e72d6973479c8c839c7f4a095d121829ebe8df39b71ebf291c84e5cb3e36e"
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
