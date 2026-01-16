class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "fb26006c708b843e4b3e754836f62a658197c3abe1834957bc9876cff58504ca"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "393d656a101e481946c9bfd013ece33ab6fc5aec9c49dbf30cb9f0824b2b55ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "393d656a101e481946c9bfd013ece33ab6fc5aec9c49dbf30cb9f0824b2b55ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "393d656a101e481946c9bfd013ece33ab6fc5aec9c49dbf30cb9f0824b2b55ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff6b1fcf71def8612e9ba1f686d5b156808c53a78775d902935d80fed2a8cefd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45bdbe9c3851bfbdc94b1c17f4f88d8998642b911da5b0a2e1495cc8fbdef106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45bdbe9c3851bfbdc94b1c17f4f88d8998642b911da5b0a2e1495cc8fbdef106"
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
