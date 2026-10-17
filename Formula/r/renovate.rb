class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.164.10.tgz"
  sha256 "5720e552ad92c627466a9cc77b3faf606bc7e2be69d3bab80c158876fbe8cc06"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1d72b26c811a157838b1f73d77d6ef11739a7ae2f4506792faeb1556ccd0503"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1d72b26c811a157838b1f73d77d6ef11739a7ae2f4506792faeb1556ccd0503"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1d72b26c811a157838b1f73d77d6ef11739a7ae2f4506792faeb1556ccd0503"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7d1514c9a1ec751c4947325e95929c5a8e648ac8ddea3a1d11a19836c887990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b7d1514c9a1ec751c4947325e95929c5a8e648ac8ddea3a1d11a19836c887990"
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
