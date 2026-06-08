class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "94c2076461aa8f8ebedd0af53344e6f9f1539fe2bbd03b1f9b40fcf0f39edab7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d28752bfe858ee5024dd1759fa18564d59511b2a55106f38be1a27526ae0faae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d28752bfe858ee5024dd1759fa18564d59511b2a55106f38be1a27526ae0faae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d28752bfe858ee5024dd1759fa18564d59511b2a55106f38be1a27526ae0faae"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b01731e338934fbf362981d6a5bf031768cfa7a27541db164b94ab5991f132"
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
