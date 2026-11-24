class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.15.tar.gz"
  sha256 "a87fbd6fec2e2f6ce4a8991e035fffcaa01797c40328c2a8114fd61d8f977b66"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    manifest_sha256 "f14d81080f938cbcd3871e445f23de77471b99cd781b41fc789a89949efbc14c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "77436aa002f8ae440f61615f90adebb9d47a39c4527e014fd9cace41c4e3a92c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77436aa002f8ae440f61615f90adebb9d47a39c4527e014fd9cace41c4e3a92c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "77436aa002f8ae440f61615f90adebb9d47a39c4527e014fd9cace41c4e3a92c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cbe28ad3fb6323778f24702f5667fcc7aab0b64abe439581cf0792c406c79814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cbe28ad3fb6323778f24702f5667fcc7aab0b64abe439581cf0792c406c79814"
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
