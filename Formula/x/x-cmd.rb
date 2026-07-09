class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.9.11.tar.gz"
  sha256 "feb97e4f3c1f173ff24de3fb2d5f4b4b7cff3c8fd8c032349a2ebe591e2e635c"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "241886f01338e358c283a00e8b998053744361073f70a02aa53741cf4876107b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "701a8088f1fdec367ead276ecbd9f32fadeb2a08084b3f076c3a8f723a42a2db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2633c608b8162537fd5309324bb085fce045badaca88c36b53403c096b7e759"
    sha256 cellar: :any_skip_relocation, sonoma:        "3433091f0d023397711530841df57d76f34ff885e221fd1a297736aca0f2e423"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df376fa3cf3c1b9a14d1160affe607bab9ff55b2a490015a000458493ff8740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1df376fa3cf3c1b9a14d1160affe607bab9ff55b2a490015a000458493ff8740"
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
