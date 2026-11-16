class Sniffnet < Formula
  desc "Cross-platform application to monitor your network traffic"
  homepage "https://sniffnet.net/"
  url "https://github.com/GyulyVGC/sniffnet/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "11774fc726862325e025b0e6c6b337671eacc1305783e8da41adc9e3ea895638"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/GyulyVGC/sniffnet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b3a93726d354537c9c5df58549dbd65547ef565c159701cb0a2b9e14b21253f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0253e9c6e7fc2aa760d14314707c95cd40b297f29ac12c2a386af840651b1de6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "635a8d53b752d3eb8e3033cf87996644c2297a0f61b4a8c7b4c661d1582a3abd"
    sha256 cellar: :any,                 arm64_linux:       "dc27074d1c133482ea7376c1332bf4f6e8a081c1eb863eaded6d6f08b15d3dee"
    sha256 cellar: :any,                 x86_64_linux:      "f13da68fbbf5f7f0e787bdb07b5d11ce23cd6bb66961ecb2c0293e5fd7cc1612"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "libpcap"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # sniffet is a GUI application
    pid = spawn bin/"sniffnet"
    sleep 1
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
