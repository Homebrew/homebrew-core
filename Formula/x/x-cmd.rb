class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "f731b0e12dbb8d8f6a7b35f3995f04edf7b72b7210057f150011de5887ac44e9"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d104c3c88dc62b0c7a974e5410a5e79763c462dda2f0b9dbce6882796c20788"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d104c3c88dc62b0c7a974e5410a5e79763c462dda2f0b9dbce6882796c20788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d104c3c88dc62b0c7a974e5410a5e79763c462dda2f0b9dbce6882796c20788"
    sha256 cellar: :any_skip_relocation, sonoma:        "7abbd9eeed7fbafc84ff23b93a0dd668e734d61a3640f25f783978640fc6478b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3594f2eae84602bb0bf6e59c8f07f05dc70ff296141adfb0566c59b44d4c1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3594f2eae84602bb0bf6e59c8f07f05dc70ff296141adfb0566c59b44d4c1c6"
  end

  conflicts_with "xorg-server", "x-cli", because: "both provide an `x` binary"

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
