class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.41.0.tar.gz"
  sha256 "1640c4acb1e429a2bb09788eb8318d114ffc61c128973cab11af7f1ba6821889"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "668eb9f75c6339635d1ffde1a20129162ef24ac8928c2009a7cb8d2cd190ddf7"
    sha256 cellar: :any_skip_relocation, all: "2dc62f13955919b9d15cdfbf1213e5eccda33589b7809a2958ce63cbb4f306e3"
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
