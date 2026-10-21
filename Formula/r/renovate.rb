class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.167.0.tgz"
  sha256 "b3ef2bb103a133f5f80fada5a347659471171a3128aea635d75baae8061cd451"
  license "AGPL-3.0-only"

  # livecheck needs to surface multiple versions for version throttling but
  # there are thousands of renovate releases on npm. The package page showing
  # versions is several MB in size (and the registry response is 10x that),
  # so curl can time out before the response finishes. This checks releases on
  # GitHub as a workaround, as it provides information on multiple versions
  # but has a much smaller size.
  livecheck do
    url :homepage
    strategy :github_releases
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c495e65cdcb23e63651d3b6408028831b3f7068fedb4697350e92124cc63c33"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c495e65cdcb23e63651d3b6408028831b3f7068fedb4697350e92124cc63c33"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c495e65cdcb23e63651d3b6408028831b3f7068fedb4697350e92124cc63c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b5faa06a9b83e28c4aef88e7c7c83e4895309677f54f34973952442fa646bbe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b5faa06a9b83e28c4aef88e7c7c83e4895309677f54f34973952442fa646bbe5"
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
