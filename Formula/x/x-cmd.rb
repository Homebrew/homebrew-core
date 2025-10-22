class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e85ac77ed4d558e92a13d6d09e36ba9994425a072d677f523003609991c802f1"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e111617d7377e8658d6202a6de66627f1964242ec1f2282f1d5aa233becff6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e111617d7377e8658d6202a6de66627f1964242ec1f2282f1d5aa233becff6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e111617d7377e8658d6202a6de66627f1964242ec1f2282f1d5aa233becff6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "fba821e8dfd51fcad27673fc3bd32e48e23660f045645483a428e738fdc43744"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e01721d374a9cadcd5d4a0a93f9fd8f9f1cf66c8d14322e724b7c86b9dba35f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e01721d374a9cadcd5d4a0a93f9fd8f9f1cf66c8d14322e724b7c86b9dba35f3"
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
