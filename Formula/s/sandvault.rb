class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "fc228a40ff270906e4142ba4cf0bcb574b4ac3bfa2e8d2974a5d360b034911c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c49babf7664cc8f5241d8fbe2fe1f283628254fb4893060b45b8ad58c70c2e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c49babf7664cc8f5241d8fbe2fe1f283628254fb4893060b45b8ad58c70c2e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c49babf7664cc8f5241d8fbe2fe1f283628254fb4893060b45b8ad58c70c2e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2978c278599aefaf14a0a6994fcb387a59568a76cd8d55c65899863eedfffa6"
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
