class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "bccf0ed5673f7da4530f2b51bdad9260f73dbbfe9e67621d51f2662297b6743e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e23465002e65559221790a5d1f17de1df272b0611d709ba9f97cfc27b13e678b"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  deny_network_access!

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
