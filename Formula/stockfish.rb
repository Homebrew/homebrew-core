class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "http://stockfishchess.org/"
  url "https://stockfish.s3.amazonaws.com/stockfish-8-src.zip"
  sha256 "7bad36f21f649ab24f6d7786bbb1b74b3e4037f165f32e3d42d1ae19c8874ce9"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6191999c37070259207340cafcee3876f8e66dc44b903f484d930072ddc7f5bc" => :sierra
    sha256 "6191999c37070259207340cafcee3876f8e66dc44b903f484d930072ddc7f5bc" => :el_capitan
    sha256 "5061823dfe7f06672ed5a0b5608e20ea141a8c6f1bf79f5ac5bedcc71ca56ba8" => :yosemite
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
