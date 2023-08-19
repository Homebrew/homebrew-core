class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/sf_16.tar.gz"
  sha256 "a1600ebdaf4e324ba3e10cec2e0c9a810dc64c6f0db5cc955b2fd5e1eefa1cc6"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c85682af4f040f57555116ac1762f6d6d4749fcf419e21e94fd91c46a50fd9ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50a5998dbabe422fe64e49fbc259bedfc2cb1e9657a6375f1ef467ece03b8cae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de69084dc86ff7a30c4b0561d2a5091d88a43c96dd5f13842d50327a8663283d"
    sha256 cellar: :any_skip_relocation, ventura:        "196f7d090cbfde5aa3aff32748f3081b4d7ea4f29588e9a5551df4e392048b64"
    sha256 cellar: :any_skip_relocation, monterey:       "5f90ccc4d589b06bcff87f70856c754074656cec63fe5252f252f13fb699fff6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a2430875eee53cf4855a1a897220115df48f5d8463c1b10d57f4db22286a3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5affbe2bf93f2b96edc4ccd453563fd961f44dd13ef96a0dd460d45e5d642344"
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
