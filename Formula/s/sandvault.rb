class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "1640c4acb1e429a2bb09788eb8318d114ffc61c128973cab11af7f1ba6821889"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "bf0c66466309c083cf03f358d79e1241c37a08745777bf0279e94ff77f692a43"
    sha256 cellar: :any_skip_relocation, all: "8699e689225dc6461378554b634a47b30e22e3d6445e167d95a377b18f6ad160"
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
