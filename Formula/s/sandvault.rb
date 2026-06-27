class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "babf9a1d2a6f899fccba8b39c5d9c836110a75da6f794f440354dc6c07fb8de9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30e90662c6bab0ed301014843cdf68267ff669bcd3b8b04fed97b7bb2addc3b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30e90662c6bab0ed301014843cdf68267ff669bcd3b8b04fed97b7bb2addc3b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30e90662c6bab0ed301014843cdf68267ff669bcd3b8b04fed97b7bb2addc3b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "effd00dad25ed336d1e09dde004cbb64b764b5eba4c15aa56336d1ca4f1df596"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
