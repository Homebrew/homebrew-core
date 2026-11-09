class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.222.4.tgz"
  sha256 "b38c81434d24cb93d58057e753ca05996c38e8dccb0454ed99648fc325d0bb32"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "705dc6c99c6f4141ec23ab3dbc18c5d82327cc80294e754373b13a3434d4e247"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "705dc6c99c6f4141ec23ab3dbc18c5d82327cc80294e754373b13a3434d4e247"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "705dc6c99c6f4141ec23ab3dbc18c5d82327cc80294e754373b13a3434d4e247"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96d3a79ccf6135df2d71f166e2d0201a316f32b2e4e8e11f8f3a06d6db01b1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "96d3a79ccf6135df2d71f166e2d0201a316f32b2e4e8e11f8f3a06d6db01b1a7"
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
