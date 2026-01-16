class Sesh < Formula
  desc "Smart session manager for the terminal"
  homepage "https://github.com/joshmedeski/sesh"
  url "https://github.com/joshmedeski/sesh/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "e8aefef5f3c9f38875313776b5af3e9c62f7f4c55c7597b9e067c34cd67c83bb"
  license "MIT"
  head "https://github.com/joshmedeski/sesh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c5eb406b2dcf898c9adb58ae230f5a0501ad44e6891bd16c15a99af89f31ece"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c5eb406b2dcf898c9adb58ae230f5a0501ad44e6891bd16c15a99af89f31ece"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c5eb406b2dcf898c9adb58ae230f5a0501ad44e6891bd16c15a99af89f31ece"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9ba38f7d84dc20084ac2d0c1e55dc697bd33cf6d855a0885c3ebd24561d639d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4efac23dafd4e276214178eb82941da3be72dc324851994e5e78536002d99bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7269610b715ad6f34d27ebdb50b88ff6baaea1f4fcd3b1b4af8a609541c287c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/sesh root 2>&1", 1)
    assert_match "No root found for session", output

    assert_match version.to_s, shell_output("#{bin}/sesh --version")
  end
end
