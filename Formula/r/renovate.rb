class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.261.1.tgz"
  sha256 "347734c74a0ea38b6d58cc1ea0f7a60d0a0ae25ce49293eab9fe5e5603906bf0"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "1e2ac5bcd30c0ea8c2dab3ef4fba92364892db9c961f832c26eb91e52f6922ff"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "22b44915df4b2f5b8e6839e712178cdd760a0a43b5acdff381ccc0c9fe1494ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22b44915df4b2f5b8e6839e712178cdd760a0a43b5acdff381ccc0c9fe1494ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22b44915df4b2f5b8e6839e712178cdd760a0a43b5acdff381ccc0c9fe1494ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c0f53ae67cdd7377bff1787dd5d337db622aa6d7caa97c141221fb8d19ebcc6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c0f53ae67cdd7377bff1787dd5d337db622aa6d7caa97c141221fb8d19ebcc6a"
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
