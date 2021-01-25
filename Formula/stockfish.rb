class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_12.tar.gz"
  sha256 "d1ec11d1cb8dfc5b33bcd6ec89ed0bafb3951cc1690851448a2696caa2022899"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:sf[._-])?v?(\d+(?:\.\d+)*)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "80f4bffca9c15c8f2744876384f2a07d1184de36e67167b5730a9c7b32e11b9a" => :big_sur
    sha256 "551132d7e63e86d86bf857b89cd6067b1c0b6461c8c2a48b9adf4edf9285ec12" => :arm64_big_sur
    sha256 "54594ab09c5f7176a52ca9b8e1a8d937420d89f8ee98b17322a82396f88e14c2" => :catalina
    sha256 "f0bf09f7f5b3a28debe09be7898bb6973524f13026d5c18eee6752450e778efe" => :mojave
  end

  def install
    arch = Hardware::CPU.arm? ? "apple-silicon" : "x86-64-modern"

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
