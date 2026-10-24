class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.181.0.tgz"
  sha256 "ff6f32c4f370718854d2d5a2bd0c854f6830acf3b01ffba805c28025b1bc6fc6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c204b2e51dc4a3894793f3768a5f4b6ee0561908c9d4d25b47b3dde7ed7d9bf4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c204b2e51dc4a3894793f3768a5f4b6ee0561908c9d4d25b47b3dde7ed7d9bf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c204b2e51dc4a3894793f3768a5f4b6ee0561908c9d4d25b47b3dde7ed7d9bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7c3a30e6c9492c01eabff8a402295971283621a54d40ad9f4e5d7cc450fc190d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7c3a30e6c9492c01eabff8a402295971283621a54d40ad9f4e5d7cc450fc190d"
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
