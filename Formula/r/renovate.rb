class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.199.0.tgz"
  sha256 "ea64ea62136b048292e693f0dc1dee4fab3c7b8e9aa96412ffedaefbd36d679f"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f165c4182cc1ea2f1f30fd06b617598ed204a6eb23bae5471486bc300ec00975"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f165c4182cc1ea2f1f30fd06b617598ed204a6eb23bae5471486bc300ec00975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f165c4182cc1ea2f1f30fd06b617598ed204a6eb23bae5471486bc300ec00975"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "afad23fb5cb2fd6c310733b7d6b9b3b2cd6910eb5ba778e78805a57cf5c46294"
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
