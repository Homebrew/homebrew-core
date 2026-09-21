class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "78eb53cad342d0efd476ce5d415533c3da8732f77c71b9ec1438b7367b784fd6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf0ee3a01005445d8a835f6bd0634117f360b1658a2ef83470e933db575ca0cf"
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
