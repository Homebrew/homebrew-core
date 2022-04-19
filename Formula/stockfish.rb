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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef5e55e732a950acb837ea3eb4adfac3fdaa2b0e1ee282d70d5f1eb2c883cc6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df0bfa47fc470ecde1d715f7ca949c3fd77a903f93a8eea9dba4b5a106eafbb2"
    sha256 cellar: :any_skip_relocation, monterey:       "bed614a1f3d7d6b9ea90bd3fdc5f6186de9de856a6468b70547a5489c5adb753"
    sha256 cellar: :any_skip_relocation, big_sur:        "11a90a078e9e3ecf881fb616d254f6ee9e921e03f382018f524d34cf09c1946f"
    sha256 cellar: :any_skip_relocation, catalina:       "a7d63b4cde1d25c2467461e0410570c7c66c9cf0285e17f13791ce26e199f402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ab8d99e0e5948551a9bea72fe37b8d6574890c0c90e84ce4a02121ae4311ac"
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
