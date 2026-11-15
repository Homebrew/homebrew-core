class Tele < Formula
  desc "Telegram client for the terminal: a keyboard-first TUI and a CLI"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "bae71e369a0b71f0e982677c8b88279db14a8e06fa2a09191eda7d969653c2a7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d1968c02d2ef6c1fc215f14ee5ac516bef5afdf4afdb296faf1d7aa03d461eb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18a3f3ab17e7757e221c728ab141fa9b34798b3849263453facf8ee68bc9e4ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f5948ce6dc657a0fde3040e55e3f6adcf6a61fa908833e6e65b730ec126b715"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "365fdd6dfff712a9073065778b989091319b101effda502c4e720f93631bc464"
    sha256 cellar: :any,                 x86_64_linux:      "07064877badaa67ce45869de0a0493d52e4a45adb3c11b2ab49aaf09c919e21e"
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
