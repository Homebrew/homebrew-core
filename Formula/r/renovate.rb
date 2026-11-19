class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.251.0.tgz"
  sha256 "f1c1b29d3092807b8999d022a550909b788b8b1439aeca54bc340aef68e8df56"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9dbc1e89280bed789d662d626cf49c7ed0f87c0e6f3cd2139dbefb07f0fc1da4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9dbc1e89280bed789d662d626cf49c7ed0f87c0e6f3cd2139dbefb07f0fc1da4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9dbc1e89280bed789d662d626cf49c7ed0f87c0e6f3cd2139dbefb07f0fc1da4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1bea72287f17c5ad17f3c5bd558409867703fb24f4ebd91ee35e8587a4a6539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d1bea72287f17c5ad17f3c5bd558409867703fb24f4ebd91ee35e8587a4a6539"
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
