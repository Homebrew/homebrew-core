class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.14.tar.gz"
  sha256 "6940eba3bf4306d4b9f463567973fb073097f7d2a5b936d1b6a295bd83f65409"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a499a66440f1eaa9d93a25be92f31074894251dea94010b434f310a8bde0aee8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a499a66440f1eaa9d93a25be92f31074894251dea94010b434f310a8bde0aee8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a499a66440f1eaa9d93a25be92f31074894251dea94010b434f310a8bde0aee8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6118b87faa02d7158f733606c11a9f6cdd11cacdf1430ce239c4fb09ec3fc1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6118b87faa02d7158f733606c11a9f6cdd11cacdf1430ce239c4fb09ec3fc1f9"
  end

  deny_network_access!

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
