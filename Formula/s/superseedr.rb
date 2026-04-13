class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "8fc206437b7a6028eced01a22841fbf0f96044fb076c35aa4305644a20e6f2f1"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2239f540854559d8a6d403d07be950a2e893b7fceae082af2727f2d443d5773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbb7da04aa07f1004abda8856bf99d12c515e91ca7596265955206a944b511e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e3230bbe3529a76f3fe9ec05ab4cb9c6129c88bdd43d9fc494c63ed4ee7c408"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3fb49fb5a1707f4cc0ef73f8b14326f4253b3ccb330e2c17b20f9bb54dd41ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb9083e31a305abc9a7452fdc9d16789799b1d15576ed6f6f0a35235fe02ed86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afaf6220884ecb6243b468ae8b04d0ad769561e118720f20527e521feb2b246f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end
