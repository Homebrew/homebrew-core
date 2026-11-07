class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.219.0.tgz"
  sha256 "c9cecfe779711ed13f3413e136b6a276a282c2fba6dadc7119927b1d8e6eb8e8"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2cd0ada72afc8fa5060e8c5e1066534a73d3b0fb5af8f18baef96d5ccbfde892"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2cd0ada72afc8fa5060e8c5e1066534a73d3b0fb5af8f18baef96d5ccbfde892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2cd0ada72afc8fa5060e8c5e1066534a73d3b0fb5af8f18baef96d5ccbfde892"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a6191e871fb553e14d57e323757988412a17446041abc57b0419cbaace468b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1a6191e871fb553e14d57e323757988412a17446041abc57b0419cbaace468b1"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

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
