class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "c95af66e13bfe57506ce9325fac36e1421a0bfae2620d31184b3ba206f20076a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    manifest_sha256 "fed97a16507c6594a9ce0d2d4cf3c1edc62b03abedcd82299a4ebd2e4eb496b0"
    sha256 cellar: :any_skip_relocation, all: "9fb2aba17a472314a446ff2ec3758fd89e3355f8eb5264c3058a388ba92ed17c"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  deny_network_access!

  def install
    libexec.install "guest", "helpers", "skills", "sv", "sv-clone", "sv-agentsview-setup", "sv-gh-token"
    bin.write_exec_script libexec/"sv", libexec/"sv-clone", libexec/"sv-agentsview-setup", libexec/"sv-gh-token"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
