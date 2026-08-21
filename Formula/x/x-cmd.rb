class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "d61ba06d046511113b0f6e3be43b5a0f2f807284c5eee5d6197f78d1aa99c9e6"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "010ed8f3b578d052539972cb050a557e915134bc96110243ac8f49bc9ca5798b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "010ed8f3b578d052539972cb050a557e915134bc96110243ac8f49bc9ca5798b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "010ed8f3b578d052539972cb050a557e915134bc96110243ac8f49bc9ca5798b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ed3178c5e939aed63607680f3097def3dd95953ae60da95f60f977718c19a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b64ca7ca0dcfc77f52975f67a8660a0ec35125ed6351cc9f13c5a08926f56ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b64ca7ca0dcfc77f52975f67a8660a0ec35125ed6351cc9f13c5a08926f56ec"
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
