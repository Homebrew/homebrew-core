class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_14.1.tar.gz"
  sha256 "11d71018af47ba047175f846be72d8d9878df698e9b5d708ab158cf530633600"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed762f6cedfdd69e4d2068b956b6abb4eb86290c9254aa1cf75edf0ee010026b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81b4c0a9df6cc42255c8795430e990ddf47a42831c5e54b1273e7b3a9221e316"
    sha256 cellar: :any_skip_relocation, monterey:       "cc49bf2f3301735a7d8f22db0e8c9b6740314abcf7d388f9e59608077ce78aab"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5483261810c53e7600cf7739e046253951413b22bfe480d522ad63bd796d4e6"
    sha256 cellar: :any_skip_relocation, catalina:       "31819d40841821593f27ab92a021ae03458b251e91c80bd0d099af2062fa6a51"
    sha256 cellar: :any_skip_relocation, mojave:         "684d804597360a5a7bc70b9392ef51b54627fdd864148eaaa10d6a3ddcbc5f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de53819aaf7d1f8679c0681ea2bc57c05d7040f8da1c6372bfa20616cc59492f"
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
