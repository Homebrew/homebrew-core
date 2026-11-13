class Tele < Formula
  desc "Telegram client for the terminal: a keyboard-first TUI and a CLI"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "bae71e369a0b71f0e982677c8b88279db14a8e06fa2a09191eda7d969653c2a7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7562762d96d13c98349fcb836c7a7914b92b3740a34141adf0cd8e458bf7a23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8b29b763f5edd373e7de06cc1f12b5b878ed6b935703c64274abbb19776449b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee3ab303f00bb3c80657811acca3f78f551af48ac2ddbf10724ec79b4d378eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9394c1f6f43c3ad96d57976dfc3df24229f1725781fb38ef0910b8d49e2c1898"
    sha256 cellar: :any,                 x86_64_linux:      "dd16ac91c68c61d47a698d9ecbd87220b2528751fba30ad6089b8682e6e25832"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/sorokin-vladimir/tele/internal/version.Version=#{version}"), "./cmd/tele"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tele --version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele --theme-dump=tele-dark")
  end
end
