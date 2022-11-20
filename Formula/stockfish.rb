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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fc7b85028b41cd7e3db3f25a9481521aef01f95611e979734b815c64631f159"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea9532bb3f1686c433a62c8eb671a0cfef3a9ead7a6a5a83475826c5bcb49e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9961c12ee12480d1dcb9f72af2b735ee6c4d686e62b0554625efe0246f9a327e"
    sha256 cellar: :any_skip_relocation, ventura:        "e9c420bf30df7268fe606e4efc481d7e6d5c25988c70eb30184c1ad81f88a1e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c29b02b056094c6f11072cf38351ad259804d97e1727c149fc8a3f6716a1d993"
    sha256 cellar: :any_skip_relocation, big_sur:        "39efb53e1d05be75937cd9db2af59e1bfd618992b455c702a23c3628e6bbe154"
    sha256 cellar: :any_skip_relocation, catalina:       "da786a5130e0126c86ce20fa078a3af16270a0b9649411e9ee64a28c370b3a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9f92ead9b38a5ffcac5fc72b052a6c63953c0cd057a142ffa7f8215cb7146c6"
  end

  fails_with gcc: "5" # For C++17

  def install
    arch = Hardware::CPU.arm? ? "apple-silicon" : "x86-64-modern"

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system "#{bin}/stockfish", "go", "depth", "20"
  end
end
