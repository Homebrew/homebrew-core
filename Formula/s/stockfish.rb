class Stockfish < Formula
  desc "Strong open-source chess engine"
  homepage "https://stockfishchess.org/"
  url "https://github.com/official-stockfish/Stockfish/archive/refs/tags/sf_17.1.tar.gz"
  sha256 "0cfd9396438798cc68f5c0d5fa0bb458bb8ffff7de06add841aaeace86bec1f1"
  license "GPL-3.0-only"
  head "https://github.com/official-stockfish/Stockfish.git", branch: "master"

  livecheck do
    url :stable
    regex(/^sf[._-]v?(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c99cb199ddc359a18b48b75a93e5f1367b402e249ae9a86c9ca2d28608ece13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f29f5e67075aa8ce69609853e6e9fd44bf6a51104b38fa2b63b265ed9295eef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ae4b4a92ca51af55b0533ee78f1571fb3e3116bb1c8a66e0efb0d2c7697159b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "817c688cfc9d4222e1d8b7b825eaef6050deeb047023454fbc0c883d946e3be3"
    sha256 cellar: :any_skip_relocation, sonoma:        "0747984f92b6ad9f16502e626b04f9acc22f5db93b15b23361f6afe430d719c3"
    sha256 cellar: :any_skip_relocation, ventura:       "5bdbb215c398e2eff9da2a249e81765b0ed403ff6ee75be84274aaf79b8728e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927330b6c83490eec6fbce9767fb3a48c9f18d9f2851084c8abe0d32940931c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a9d4a3b90c9997b46ca4d7c70fbb0511c2922a51e8f6e9648cc876d0c296a3f"
  end

  def install
    arch = if !build.bottle?
      "native"
    elsif Hardware::CPU.arm? && OS.mac?
      "apple-silicon"
    elsif Hardware::CPU.arm?
      "armv8"
    elsif OS.mac? && MacOS.version.requires_sse41?
      "x86-64-sse41-popcnt"
    else
      "x86-64-ssse3"
    end

    system "make", "-C", "src", "build", "ARCH=#{arch}"
    bin.install "src/stockfish"
  end

  test do
    system bin/"stockfish", "go", "depth", "20"
  end
end
