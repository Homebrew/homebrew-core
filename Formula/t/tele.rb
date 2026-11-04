class Tele < Formula
  desc "Telegram client for the terminal: a keyboard-first TUI and a CLI"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "9c794adadb60eaf462106b0120624c1d53a4694ca417de2b65a40f358fb25785"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec2cec55d0b74e692a452753e8957be0437a1baa3540def42d4dd04fefee447b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4d37b1f96edf91591e67893a545982d2b139b1b864f3f8c57c503e8cb422c6ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27f5ddfcc97b26d1b238020c64cd26bb8989ac4e345c2c5f0d4153e4b9fcde9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9288723522f5bd212bd7cbd341edd089f8837f22032fa6abb0f3d43344633586"
    sha256 cellar: :any,                 x86_64_linux:      "e405def1a9c39807023d2ed7fa0728d28e591a3bca89f4bac2e3224ce02fd843"
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
