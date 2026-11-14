class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.238.2.tgz"
  sha256 "ae44bfd86711df46db7c602133669e66161ec3fb5e8d84fdb86aa8de094737a3"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1879ac2cf2803611e892089f489226fdcbd0b09b98552185aa0e79f7c3487d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a1879ac2cf2803611e892089f489226fdcbd0b09b98552185aa0e79f7c3487d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a1879ac2cf2803611e892089f489226fdcbd0b09b98552185aa0e79f7c3487d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c2f0d3eaee84a6e115427111ec16d6ed8ca238c4447f4e4dc5110a8049e39e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c2f0d3eaee84a6e115427111ec16d6ed8ca238c4447f4e4dc5110a8049e39e76"
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
