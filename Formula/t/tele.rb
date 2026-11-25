class Tele < Formula
  desc "Telegram client for the terminal: a keyboard-first TUI and a CLI"
  homepage "https://github.com/sorokin-vladimir/tele"
  url "https://github.com/sorokin-vladimir/tele/archive/refs/tags/v2.1.4.tar.gz"
  sha256 "a06981a19a74d9ed63930e9f81ef70fd2e7bd301c2b5968eed8b1c684bb32d7a"
  license "GPL-3.0-only"

  bottle do
    manifest_sha256 "948eccfd2978d6a7967886d33916d40fd4950497af1bb8fb11d77130ddc6bc0c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a649b77954926246c1876ca0be383216e07940085ca8a5c12d2b46b2e5f383ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "376ec6f88ca5a129407ad9e4585fa92ac70ace5d4df30747cd8d8aeb284fc847"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b4c7c9684a27c0cf12a5968161032340b6477a96fc90ffb1f82b56bbfb44968"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4231623163874679f4e56f40d552435287fc3073ce6224325efbaec7ef506069"
    sha256 cellar: :any,                 x86_64_linux:      "4cd8dfb5092334b5d93d08a5721cfd36ba76d70838fbdaa9ecf806a478b5f003"
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
