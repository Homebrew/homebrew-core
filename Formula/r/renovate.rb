class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.258.1.tgz"
  sha256 "45bca7fe76ed5305154c8a11e51bd077ebceb3135f75caf17aa71eaaceb6f07c"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "a313fce5ab017267e701bca4eeff83f8dfd64407574d8d49e5f92ad3cfe1b205"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "06d70ef233986d35b40f3408f91faa7d43bb84d2be99e9038fe352b2e27a94aa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06d70ef233986d35b40f3408f91faa7d43bb84d2be99e9038fe352b2e27a94aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06d70ef233986d35b40f3408f91faa7d43bb84d2be99e9038fe352b2e27a94aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1541aa166e7588fe8b8e10c43588017fa4e543d8f5f90514dac4ca7c1b3a4592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1541aa166e7588fe8b8e10c43588017fa4e543d8f5f90514dac4ca7c1b3a4592"
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
