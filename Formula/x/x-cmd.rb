class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "213e1b7f9351c82bcdcc996891c0a2221785d85c2b6d33c299904036b5b4db47"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190373f69d5b6c8fe1f4a4a3d237e6ef36e9c4bf7339c188ea69494dd09816f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190373f69d5b6c8fe1f4a4a3d237e6ef36e9c4bf7339c188ea69494dd09816f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "190373f69d5b6c8fe1f4a4a3d237e6ef36e9c4bf7339c188ea69494dd09816f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "22720cbc4b2d4905436f7758174a7c7a3eb5a587b0c3f1be97f1b1a809fe4d37"
    sha256 cellar: :any_skip_relocation, ventura:       "22720cbc4b2d4905436f7758174a7c7a3eb5a587b0c3f1be97f1b1a809fe4d37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a491fdf7ec078aeb15ccbc997dd935a76a89a534ec05c477cb9bc55662f16e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70a491fdf7ec078aeb15ccbc997dd935a76a89a534ec05c477cb9bc55662f16e"
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
