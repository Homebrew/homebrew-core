class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.240.0.tgz"
  sha256 "1580983c28e0c506073a6178bd2656fcad03c2b9995a6d5d44d540cad156da08"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1311482b1d3e4b42dc7ad1624622e1b653bcc8c9243bc3c99c8cef637151fd9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1311482b1d3e4b42dc7ad1624622e1b653bcc8c9243bc3c99c8cef637151fd9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1311482b1d3e4b42dc7ad1624622e1b653bcc8c9243bc3c99c8cef637151fd9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "153b79e1cfa95cdda68a82391ea1c59faa8cb3192cc79dc3447aa1e8794408f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "153b79e1cfa95cdda68a82391ea1c59faa8cb3192cc79dc3447aa1e8794408f1"
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
