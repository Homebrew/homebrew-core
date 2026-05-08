class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "694e2cf6973c58756052d3176a7ecc90949642d27b81c4f2c5ea0cb5fbd39e4f"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0ac955dd6598fed72fa27024df8b460e7c1c46caf161f7da48541beba663527"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0ac955dd6598fed72fa27024df8b460e7c1c46caf161f7da48541beba663527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0ac955dd6598fed72fa27024df8b460e7c1c46caf161f7da48541beba663527"
    sha256 cellar: :any_skip_relocation, sonoma:        "365cdaf9b0f3296c230f114a9b3847b56dab6bd97c55053f3e151de8c3a7fbc9"
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
