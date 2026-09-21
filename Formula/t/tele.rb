class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "cb9686d96aa727f9c4b31d3d65a98c5f6196bd5dfdbb57f2c16612fef3302631"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b87d6ee2d15b8f7673258ea17523f22ba9e9c75e76cb4c08d17df0d47994975"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c90769aa794f57ab3d84788dff5e1e5c337b073c75af532f771a6e8922f1f2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7fdfad5eab1256c1a63c523411f80e2564890239f078449edc8ef7b513f5e111"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "40ffdbfa4b551dc35b2623132bf28eafd656ce9e1782b1bb2e0417106d92e6ca"
    sha256 cellar: :any,                 x86_64_linux:      "11d573d9125e65d45f8bcb2c0bb9fe3a3f948e97dea38515ba61635f72c89ce3"
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
    assert_match version.to_s, shell_output("#{bin}/tele -version")
    assert_match "dumped from tele-dark", shell_output("#{bin}/tele -theme-dump tele-dark")
  end
end
