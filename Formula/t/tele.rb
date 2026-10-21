class Tele < Formula
  desc "Keyboard-first Telegram client for the terminal, written in Go"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v1.11.13.tar.gz"
  sha256 "6cce73db52e0a25b4f0f5d76d8151e1105d67f02309e359b908007f4af50dcdc"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51202c46a80929e99d863a19dfc31fd07e1da0f06945d1c7b52defc7f51f5cc1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a135165663145843853db460e29a4f75b07324e213ea27634dbd9913273623f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65afdae24a79ff293bd93b976f33ac9c6389dfd90f8c5e97b3ada961e509bfad"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "54627e20f8e24d576d08f3fcf32ac737f4f684fbe1a356e82989c3299aa5bb31"
    sha256 cellar: :any,                 x86_64_linux:      "d57ed6fcba17dbfc93cc35d3654ed6e1713353d963616c54b13a312d74dd8f41"
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
