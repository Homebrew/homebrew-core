class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "7d588a2d45fed00339201a5e159b9f5424a597b36e5037203d5f35bb70eab221"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1faaaa09701d083fdcf09a48b5610b03340be075b45f8778031bf749cf319dd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1faaaa09701d083fdcf09a48b5610b03340be075b45f8778031bf749cf319dd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1faaaa09701d083fdcf09a48b5610b03340be075b45f8778031bf749cf319dd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "02042a8d9e6698419f2ae100784a850d2aadac46a95d7af33b85fcabe8d2ba47"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv"
    bin.write_exec_script "#{prefix}/sv"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
