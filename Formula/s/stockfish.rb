class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_16.1.tar.gz"
  sha256 "a5f94793b5d4155310397ba89e9c4266570ef0f24cd47de41a9103556f811b82"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da1930a5c5a3d8bf6114cd44cd19c7bdc32ab8db3d986ab7ed3eb373149b8d57"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "192db669ced3f8274f846f6e10b0a00a5c9c7b65be23c9b7fc109921f7e6ec3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d8364bebb769bda3ab8afbc7b15594da730fe8c318ee49ea8169e116ba1d76"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8ddab5e047308b049e48d2a535b58c388def6dae99a9e6f88378008e14dba80"
    sha256 cellar: :any_skip_relocation, ventura:        "ad2f1d36b3378417e9ad77729f21dda76526d2f624cd88e55ab0c7da5e0522b8"
    sha256 cellar: :any_skip_relocation, monterey:       "c4074394b6956768b9af3128b7739814c8dcc039fd06257132d43d6fdc2726ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f82e1a7783b5bafc5af9517e555c1729bf8c439cbe93717b33bec72988b1f97"
  end

  fails_with gcc: "5" # For C++17

  def install
    arch = Hardware::CPU.arm? ? "apple-silicon" : "x86-64-modern"

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system bin/"stockfish", "go", "depth", "20"
  end
end
