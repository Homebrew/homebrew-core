class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_15.tar.gz"
  sha256 "0553fe53ea57ce6641048049d1a17d4807db67eecd3531a3749401362a27c983"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775aa929a7068fe8c55b17658a75a09a8b3191fe95339ec8366bf4b5caf48be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d584b40e695a1ed4eb19b4b6e1013c580b28e74f3ca2bdb25a15ce1b5473db4"
    sha256 cellar: :any_skip_relocation, monterey:       "6747b74d9cc107ab4d0e7b6f051a9f96a30f5dac53c2fbfbac49c0ba246326e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5336ae6cdc7d0ad712a527102209156c5a5b12ef8238606798f996b528e41d57"
    sha256 cellar: :any_skip_relocation, catalina:       "fb242d484c460218a677549600fd51a6d82f1cc47751283d2047ae8b5dbbaa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87210cffd22b657169dfc10428a1ab92ebfd3029f5c051fdc5006e35cc61b5fb"
  end

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    arch = Hardware::CPU.arm? ? "apple-silicon" : "x86-64-modern"

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
