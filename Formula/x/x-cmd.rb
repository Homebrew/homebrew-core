class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.14.tar.gz"
  sha256 "5b2cb509f714e01584f3086b3230ceae4683210f1f69531f0f63b3fb0f5f23fa"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dae8e25fa3bc45384d8d569e748c8e1ddc3b970329671ce5eeefd323faa448a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae8e25fa3bc45384d8d569e748c8e1ddc3b970329671ce5eeefd323faa448a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae8e25fa3bc45384d8d569e748c8e1ddc3b970329671ce5eeefd323faa448a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c5634b18491d7035554e1fffbc3fe20066e103e041f38a6c3d3138bcf8e7271"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "724fc5b2eca02ad2eb1b3c4c08a7d41ff50b29205e08b6d78e3cc92a770724fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "724fc5b2eca02ad2eb1b3c4c08a7d41ff50b29205e08b6d78e3cc92a770724fa"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end
