class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://stockfish.s3.amazonaws.com/stockfish-8-src.zip"
  sha256 "7bad36f21f649ab24f6d7786bbb1b74b3e4037f165f32e3d42d1ae19c8874ce9"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
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
