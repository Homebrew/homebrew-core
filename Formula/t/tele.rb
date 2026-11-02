class Tele < Formula
  desc "Telegram client for the terminal: a keyboard-first TUI and a CLI"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "2cafe356dce0778a10c62aa76f3d8d2931586f1bae6e615be1f7c2fdd1c6ce7d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e521cd3fcf452b65e115ac428944ba87317a308cf085d8d2b02e1014037d1ae3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb6b816291cb9a9449d8f7a975014d91008089b67c50478184d381b4725ba135"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "83091d9dac0b0c82fdb4bfccccc43e1ca5b9bc519c1ff61f6d434f8cd7cb37b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "da75fc98e071ced0572cdd1553c5e782f0055c26705e786b3e1e0c8b22e92f17"
    sha256 cellar: :any,                 x86_64_linux:      "4828aa999ac0a77e02bc94f01a910473c0336cfcb968a39907437b7ce9426aa1"
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
