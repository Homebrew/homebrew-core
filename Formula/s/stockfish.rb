class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_17.tar.gz"
  sha256 "8f9b52285c3348c065b7cb58410626df16d7416a2e60a3b04f3ec7c038e67ad1"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a5f6a739d346d51452584203e1ee9d4073a23bede03f57a2be353cbd9e414d1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "912b422a2d146ee732c4cde82393546be33ebc530061277b76af0d0520dd31ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21f84fd184baf6d59bd0bb2181b9757cd7e0eefb902b8aee1caa773aaa50ff67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b5450bae791e55f07994c3fc5cf1b355df928e4c08e3e122d4616167de4cc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "710b857f281feefa4d483092a4ec85a603ec346712dfd53b4116ad7b4f80f8a0"
    sha256 cellar: :any_skip_relocation, ventura:        "00a1a04692ce42912e4c965d6d4825bcf7e78bd998c18eb5df74f8d82903e772"
    sha256 cellar: :any_skip_relocation, monterey:       "6a1e9587ef0018e5490ab8a610d52eae4cf9abf9c55e49c08305234a7d9add16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e5258684ddb0eba1731a862ea563030fa502849c970022678e2bab5e3fb8d6"
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
