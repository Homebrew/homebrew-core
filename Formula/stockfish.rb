class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://stockfish.s3.amazonaws.com/stockfish-9-src.zip"
  sha256 "ba2e72d6973479c8c839c7f4a095d121829ebe8df39b71ebf291c84e5cb3e36e"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb32a58f2fb8bf00e83c4ffc955d758ad4df9f7b03222ae7bf896680252b1817" => :high_sierra
    sha256 "5db21467b27838a4ed54910d457690a34c011b9a0e51208aace1064f8bb33dba" => :sierra
    sha256 "5db21467b27838a4ed54910d457690a34c011b9a0e51208aace1064f8bb33dba" => :el_capitan
    sha256 "eabc1553a23ca9305ffc523afa9432772f144b48dcd6315a2f196ae512825279" => :yosemite
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
