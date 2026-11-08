class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.222.0.tgz"
  sha256 "5291d4cc029530f7330ac8e566e00e0e17cdb81c0d6861721cd583f1a0311942"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b724221d75ebd3ec56b36c2cf65a6e3232d3858e527beedfc6c15550f9e4d2c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b724221d75ebd3ec56b36c2cf65a6e3232d3858e527beedfc6c15550f9e4d2c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b724221d75ebd3ec56b36c2cf65a6e3232d3858e527beedfc6c15550f9e4d2c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "026b05aff917331fc79eaec5250fa74f0c02d6224bbf7e5e8701199308c96c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "026b05aff917331fc79eaec5250fa74f0c02d6224bbf7e5e8701199308c96c1f"
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
