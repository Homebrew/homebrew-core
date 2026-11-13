class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.235.3.tgz"
  sha256 "33bc25727363837acb50c448c29cad895499495b2175186682eb472deb16572f"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f73fe4cc14a73d2a16e6a0d79834d0d81f15445947036c2c16d0e3779adeae16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f73fe4cc14a73d2a16e6a0d79834d0d81f15445947036c2c16d0e3779adeae16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f73fe4cc14a73d2a16e6a0d79834d0d81f15445947036c2c16d0e3779adeae16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba8311e0063801c4158c84096a5c5082695e1d1cadfc197611289bad17c5d054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ba8311e0063801c4158c84096a5c5082695e1d1cadfc197611289bad17c5d054"
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
