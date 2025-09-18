class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "fc6c7eda5ca59adb051b6b5fb781ad6f7dcbb4181f80862270171a884b5bfe5f"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00fb651b0b84b8cdf9cc84aed8a02ca5a4aafafe0b7a867633530e91c89a8b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00fb651b0b84b8cdf9cc84aed8a02ca5a4aafafe0b7a867633530e91c89a8b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00fb651b0b84b8cdf9cc84aed8a02ca5a4aafafe0b7a867633530e91c89a8b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6b539a0596b6de49e89ee228dfde638a72b444307c52b7a22214fff9c1169a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df082579d7a66a903f415e7f22720c21f6725326a23e7126aec2c5b79fc58c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df082579d7a66a903f415e7f22720c21f6725326a23e7126aec2c5b79fc58c70"
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
