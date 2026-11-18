class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.247.1.tgz"
  sha256 "24c37b3ea4b9272f1492f821486a7161c908ecc1086c6f43a3b849a6692666e2"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8a5daecc03fa0b8bca13e6c5f9739572aa6eb3fbd5725b8c0f2004729cc64802"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a5daecc03fa0b8bca13e6c5f9739572aa6eb3fbd5725b8c0f2004729cc64802"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8a5daecc03fa0b8bca13e6c5f9739572aa6eb3fbd5725b8c0f2004729cc64802"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe9adc4e6fd7c877570b6c3984ea36d68fa7c05202ea2f35ffb958bc06099088"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fe9adc4e6fd7c877570b6c3984ea36d68fa7c05202ea2f35ffb958bc06099088"
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
