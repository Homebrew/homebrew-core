class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "5f6a0214dc42790e7ac21ed58ca928e74b1682713b791b86a64edb656402b34c"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1502beb7ffdf176bbcef0ec002acc906336130b7b5aea80d597edf7ef018687"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1502beb7ffdf176bbcef0ec002acc906336130b7b5aea80d597edf7ef018687"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1502beb7ffdf176bbcef0ec002acc906336130b7b5aea80d597edf7ef018687"
    sha256 cellar: :any_skip_relocation, sonoma:        "064571bc27ecd600c9a47377d58629151df5e373e770c85e5c5633a8090e4a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3941b788268da06c18f9b56d6e615c1e43d372625dc1a6b722c4f3db67d5420f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3941b788268da06c18f9b56d6e615c1e43d372625dc1a6b722c4f3db67d5420f"
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
