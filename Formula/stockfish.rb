class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_14.tar.gz"
  sha256 "6f35e3e684da87d27d3f29ec7281ac81468a5a86b4d99ac5c599addc984a766c"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81b4c0a9df6cc42255c8795430e990ddf47a42831c5e54b1273e7b3a9221e316"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5483261810c53e7600cf7739e046253951413b22bfe480d522ad63bd796d4e6"
    sha256 cellar: :any_skip_relocation, catalina:      "31819d40841821593f27ab92a021ae03458b251e91c80bd0d099af2062fa6a51"
    sha256 cellar: :any_skip_relocation, mojave:        "684d804597360a5a7bc70b9392ef51b54627fdd864148eaaa10d6a3ddcbc5f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de53819aaf7d1f8679c0681ea2bc57c05d7040f8da1c6372bfa20616cc59492f"
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
