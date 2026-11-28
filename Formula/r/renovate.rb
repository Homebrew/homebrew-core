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
    manifest_sha256 "d92fb3670c0ca5e889d289f6174e613f9c4e9f49ec126943a6282d87905bd234"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2cc2107b2d1b93b168d6ffc5eeabfc8b489c3bb237b7a3d9b70474c47b616abe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2cc2107b2d1b93b168d6ffc5eeabfc8b489c3bb237b7a3d9b70474c47b616abe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2cc2107b2d1b93b168d6ffc5eeabfc8b489c3bb237b7a3d9b70474c47b616abe"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fa6bf9e7d95a1e9b768d818a15e203b8197192cf437575ec5b5ce9dfa89fd056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fa6bf9e7d95a1e9b768d818a15e203b8197192cf437575ec5b5ce9dfa89fd056"
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
