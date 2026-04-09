class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.11.tar.gz"
  sha256 "e8873f8cac34c35466a077cf55691b8e50dd95a6b02b05b8920dae3edb791e85"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4b6dbf2a29dae947ff41d3676b78c8a26adfbd1f335cceac928903b57aac4ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b6dbf2a29dae947ff41d3676b78c8a26adfbd1f335cceac928903b57aac4ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b6dbf2a29dae947ff41d3676b78c8a26adfbd1f335cceac928903b57aac4ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "64e9a0481039f50593bcc31c8fb7437755737d8961b59cd10e6b9dacb4678d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7c92d8f22bb8f576fd83aea820b04c9d3cc34a29c848330b7f09522a88959b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c92d8f22bb8f576fd83aea820b04c9d3cc34a29c848330b7f09522a88959b5"
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
