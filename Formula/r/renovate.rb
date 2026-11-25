class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.260.3.tgz"
  sha256 "4c4382b241e00d1a096e6a22df60fda07b9629cfa26cba0351a54a3f6abf14f4"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "dc02624c29cc5afd74d7c34b80328859d84f8c86260f1c4b3a26466626a8e0a2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a341373efca1c310d922eff7ddbfad7614ce29928a2bda23a508e7f9cf9e8af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2a341373efca1c310d922eff7ddbfad7614ce29928a2bda23a508e7f9cf9e8af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2a341373efca1c310d922eff7ddbfad7614ce29928a2bda23a508e7f9cf9e8af"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47d4fbf230412cf7caff2678165f9d08bebac5ce14875f6cbe7c3bb2939769bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "47d4fbf230412cf7caff2678165f9d08bebac5ce14875f6cbe7c3bb2939769bd"
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
