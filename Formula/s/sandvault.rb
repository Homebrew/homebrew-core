class Sandvault < Formula
  desc "Run AI agents isolated in a sandboxed macOS user account"
  homepage "https://github.com/webcoyote/sandvault"
  url "https://github.com/webcoyote/sandvault/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "4c74a9c8651d95531dc539b8629e6767dd60b67c9d62f36cb1aadfa33c30541f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e79d2bcb7d1377b12667b289506d79e2f60333a0779ae2d3085b992fe128e4f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79d2bcb7d1377b12667b289506d79e2f60333a0779ae2d3085b992fe128e4f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79d2bcb7d1377b12667b289506d79e2f60333a0779ae2d3085b992fe128e4f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38ccf2d813b3d1669daa36be31c1cf1e715e322e0a61a1cfde7d646006b372d"
  end

  depends_on :macos

  conflicts_with "runit", because: "both install `sv` binaries"

  def install
    prefix.install "guest", "sv", "sv-clone"
    bin.write_exec_script prefix/"sv", prefix/"sv-clone"
  end

  test do
    assert_equal "sv version #{version}", shell_output("#{bin}/sv --version").chomp
  end
end
