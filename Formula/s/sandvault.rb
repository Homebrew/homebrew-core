class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "ba5cde2a5305c01710752181bc6e25944056f2bca4780705016367f64537cc86"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "138362d61026e2e8e515d5a8ef4bf3ef6fa0589e450d1dea4e9a41497801ce4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "138362d61026e2e8e515d5a8ef4bf3ef6fa0589e450d1dea4e9a41497801ce4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "138362d61026e2e8e515d5a8ef4bf3ef6fa0589e450d1dea4e9a41497801ce4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "40db7eaf8d49429b47d0dee65fc23cce304d80de1a11f43a5e2c1d3004e6c0ec"
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
