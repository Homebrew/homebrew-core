class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.247.2.tgz"
  sha256 "6c26dbeb33dfef37354227814562fac705e54d9fc50e56abc5095f1bc05c7977"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6bac11192d8f20e2e68a258fd7d751b287f29434912119d90eb3de30241eec5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6bac11192d8f20e2e68a258fd7d751b287f29434912119d90eb3de30241eec5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6bac11192d8f20e2e68a258fd7d751b287f29434912119d90eb3de30241eec5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e56cceb4bb8703ca7779b184ff10847174a4ac7e539021faa602885ebe852b57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e56cceb4bb8703ca7779b184ff10847174a4ac7e539021faa602885ebe852b57"
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
