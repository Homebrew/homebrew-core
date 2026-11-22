class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.257.7.tgz"
  sha256 "86b9d8f32a655d9a84a59fe9ef4cdb70cd4557ec696690fd3797b0225b88dbae"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "f5189e5eaec5347cd1af84bb79aa5383ab5ba7825729b5a480d342f8a727b5de"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d62fc99a92e6361d1941760018be7fd11a2465844dd0fb96437a4e959619a53"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d62fc99a92e6361d1941760018be7fd11a2465844dd0fb96437a4e959619a53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d62fc99a92e6361d1941760018be7fd11a2465844dd0fb96437a4e959619a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec09def7e226059cccb046db01db17b2e402542c4948ddb8ee56c48b82f53343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ec09def7e226059cccb046db01db17b2e402542c4948ddb8ee56c48b82f53343"
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
