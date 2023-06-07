class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_15.1.tar.gz"
  sha256 "d4272657905319328294355973faee40a8c28e3eecb0e7b266ed34ff33383b76"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53fa3f44104117cbf23416b030a53a63fb546470f41db2d3f5e8555cd2c94fe4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e941443af58f837b53dfe7c48759754c02dfe37a7a61ac1639548efee41e8cb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4737e766bab91fd04b9bb488f957143697287f4d21bfcdc92669109acaf0856b"
    sha256 cellar: :any_skip_relocation, ventura:        "d3f123462496fac8824d12c3bdfbf0b8144063ff1884a7626b03e52d59484f9d"
    sha256 cellar: :any_skip_relocation, monterey:       "e6190eb317bc6406b693e5c3f1a0536956f3616a6c65d99d8274005e8478b17a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2481ea1063c7d058c998b291897eab347c7bc59e14532664031836d94068653"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3eaf9bdabb2d9a7965ed16db5c39984f6a301a728600066042b937b86e764465"
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
