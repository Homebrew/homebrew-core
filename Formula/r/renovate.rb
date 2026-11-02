class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.201.0.tgz"
  sha256 "529440d1427760db1389fe2f5a5f9ed3120556a65dc74d68bc5bc5adca4d12f5"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f41ec87c6384322b7fc10229664fe3eaa49f62dc6bf91d8065781ef5900399cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f41ec87c6384322b7fc10229664fe3eaa49f62dc6bf91d8065781ef5900399cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f41ec87c6384322b7fc10229664fe3eaa49f62dc6bf91d8065781ef5900399cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5cb558c5695f58c9289369a94fefb7db425fc8bdba1cd039eef9f58d284414c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5cb558c5695f58c9289369a94fefb7db425fc8bdba1cd039eef9f58d284414c6"
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
