class Tele < Formula
  desc "Telegram client for the terminal: a keyboard-first TUI and a CLI"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "2cafe356dce0778a10c62aa76f3d8d2931586f1bae6e615be1f7c2fdd1c6ce7d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d274b1896a5832bb3d9d00b886b67a72196ec4c33d1f38e2483bfff12ce610f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fce35b171e1fea4ab11ea4964d50cc9ba7404ea5e62aaf8ae9508fbde9f0400a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "299fac0589233a7e3e6f126be756b94a0814031b4972ccdb366a89ec1fc04b3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "26e17e06b7515dc40432450fcc6b42ee2c656cffe723cb322cfa79d36d015f16"
    sha256 cellar: :any,                 x86_64_linux:      "f027e862ea10a0542e69dac7063d3471dc3f6499263fde84271810a6aa7e7798"
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
