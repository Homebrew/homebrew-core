class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.256.1.tgz"
  sha256 "f65babc74fe51233b33f2b72f0369b4718d520a63be8e2e5cdd53b7f360a4bb6"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b8413143b95423191579eb91b1d675da937c599c279c0e4d2f437a8f8f808d82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8413143b95423191579eb91b1d675da937c599c279c0e4d2f437a8f8f808d82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b8413143b95423191579eb91b1d675da937c599c279c0e4d2f437a8f8f808d82"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2d0fa0af382519add82e43da27d88b6f418d99bbbd3b87d701f55a42856428bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2d0fa0af382519add82e43da27d88b6f418d99bbbd3b87d701f55a42856428bb"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  allow_network_access! :build

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
