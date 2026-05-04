class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "ba5cde2a5305c01710752181bc6e25944056f2bca4780705016367f64537cc86"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41e408a1f1e2a0869124466a9b10c2c5df8f93e4bbd997aaeab222e7473c42fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41e408a1f1e2a0869124466a9b10c2c5df8f93e4bbd997aaeab222e7473c42fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e408a1f1e2a0869124466a9b10c2c5df8f93e4bbd997aaeab222e7473c42fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5e17f20bc431e9e7fd4fb26a2333b7e9182c5b4d3672cf03170f467294f15ee"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
