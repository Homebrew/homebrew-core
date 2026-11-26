class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.42.0.tar.gz"
  sha256 "c95af66e13bfe57506ce9325fac36e1421a0bfae2620d31184b3ba206f20076a"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "7ec26c6a6c1b75c7194f97005398b187f1fb6f607b097bd2f0bdcd71bd3a9a7e"
    sha256 cellar: :any_skip_relocation, all: "52fd3917c0c8aac5f14c4fd30ad25a3ab7a6e6170cc35974f4b8ed59e39729a6"
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
