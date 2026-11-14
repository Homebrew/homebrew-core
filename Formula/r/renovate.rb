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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13a465de9ae4776570b869c83ddbb73d868421729e0aec43396ef4d93420d72b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13a465de9ae4776570b869c83ddbb73d868421729e0aec43396ef4d93420d72b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13a465de9ae4776570b869c83ddbb73d868421729e0aec43396ef4d93420d72b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85e6e86da59f6402e482e91ff41e7c2137f7c54c3f45d4967c1a19d54fe85cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "85e6e86da59f6402e482e91ff41e7c2137f7c54c3f45d4967c1a19d54fe85cbe"
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
