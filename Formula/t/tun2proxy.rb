class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.21.tar.gz"
  sha256 "5f694f31fe1bdeee8261ed61b79377f4f5fac70038d4c27c16c49da20f04b667"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "605b9bd3e2122b4137b9472a5845f86141a566417823ea1f3761fd6cb633197f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6670ab4f7f4ddaf9906c8b8ca0b4919d9b18c5a001e59f6729256b242534e13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5d4d8d703db49b8f6c99e08d34376a398b20ae19a0dd21c86472c5095fc617e"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb8fa9814a1a28c7aaeef550ddc84ff1b699a758fb51b0f4e20d8a4840f71fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f3fb8d9cf5bcb0640237b6df419ecdf461a867122a8ce19af2b684b89d64cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb9dcd14ba47f83835deeffd25e4073a8267641faf22e7e63b67c464c35ebb3b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    expected = if OS.mac?
      "Operation not permitted (os error 1)"
    else
      "No such file or directory (os error 2)"
    end

    assert_match expected, shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
  end
end
