class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.263.5.tgz"
  sha256 "3c11570b524ba3be99c496644ae6b3992208ebeca8aca1118a124163bb3975b8"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "89931f26e36c5fc3553803f1f1068d75f9967996458aca59feb787b68b1fa1f2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eabe3315412d35a7544dfcca35d0ff487c3ecaff69f18d9f14cd2f617b69daf6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eabe3315412d35a7544dfcca35d0ff487c3ecaff69f18d9f14cd2f617b69daf6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eabe3315412d35a7544dfcca35d0ff487c3ecaff69f18d9f14cd2f617b69daf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f172184b371d661156a0e9de69be9e00d1b9e99cbcbc9f7b85b89244d8ba5bb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f172184b371d661156a0e9de69be9e00d1b9e99cbcbc9f7b85b89244d8ba5bb2"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
