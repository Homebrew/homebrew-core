class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-45.1.2.tgz"
  sha256 "54f9dd58c97ba3b6f8b082526716156d2fed687edbbaa9c4af463103557f6f41"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "fc9dc45f2a351278d33a9a5e077fffc99aadb161d7f8029fb6918ee2cf57a933"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c59e64c100058a6770bfd420eee1592c9705497ec38e575832376b84ea4a3563"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c59e64c100058a6770bfd420eee1592c9705497ec38e575832376b84ea4a3563"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c59e64c100058a6770bfd420eee1592c9705497ec38e575832376b84ea4a3563"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "126780c35524c26425aebd5d74f42749b4d9d96841fc449d1b85753efafddcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "126780c35524c26425aebd5d74f42749b4d9d96841fc449d1b85753efafddcb3"
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
