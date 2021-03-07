class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_13.tar.gz"
  sha256 "15d14721b3be17c597535bdbb44fb951a1ee948312d90fbf55fa0e52b8b81d62"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a695ec759970fee9683ea548aaa9d90a0e355965f813d6eb3561b15a15ad4390"
    sha256 cellar: :any_skip_relocation, big_sur:       "76291e5d29db6a4c5c9bd3fe6ca728294cc5f6bc67610831a214e7d98ab7d47f"
    sha256 cellar: :any_skip_relocation, catalina:      "2786e7ccf04a15f45861c6949caa3b11219353bf3c2aadc03e8bbc2114ecbc67"
    sha256 cellar: :any_skip_relocation, mojave:        "e375b405f0d4f38eb8b9fa73156817a62777e80d350b9ef46b0088bf3cf739fe"
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
