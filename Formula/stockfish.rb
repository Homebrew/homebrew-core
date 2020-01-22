class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_11.tar.gz"
  sha256 "802261cc601b67bed00c0ef7d21e2125959630f0852a06db9fc9bd74f440b199"
  head "https://github.com/official-stockfish/Stockfish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "788bbe949f69b99c2ca0220961aa3ad2cdc05487340d54b44b964f62ca076d3f" => :catalina
    sha256 "7e7d58466b8d4f325e69eb593dbb40074541e383b9b1e62dae83b3d9cddfc3a7" => :mojave
    sha256 "be82b92aa3b8a89162caca9f206645cb6395b93898f7575ea782f754b2183bd8" => :high_sierra
    sha256 "84e6d5d13b0a30843ed3eafd245a3c6a61ecf67635b3b18ba5950fb69aed1bb1" => :sierra
  end

  def install
    arch = if MacOS.version.requires_popcnt?
      "x86-64-modern"
    else
      "x86-64"
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
