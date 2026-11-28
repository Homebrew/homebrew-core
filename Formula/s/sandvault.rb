class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "ad77878f010df0c358f950ad2148b34ba5441684053b701070a98bf10d50f797"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "212690eaa507fa6ed9467ba9789f5d88c07d4588050a67c1a953c32004f9ac5b"
    sha256 cellar: :any_skip_relocation, all: "5d845f47ce5fe8d66b5960559395dd988d7b8e90e1d39bdd70ad2ce86d21c166"
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
