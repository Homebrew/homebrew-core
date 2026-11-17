class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.240.0.tgz"
  sha256 "1580983c28e0c506073a6178bd2656fcad03c2b9995a6d5d44d540cad156da08"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0e211e10d97555426febdd0af9dba9abef56b6d19682100e6a54d9ed257c625"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0e211e10d97555426febdd0af9dba9abef56b6d19682100e6a54d9ed257c625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0e211e10d97555426febdd0af9dba9abef56b6d19682100e6a54d9ed257c625"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88c8ce4451b9d8e3219548b4d42a0ed11e4fca55b23fdf57acfe5383c6fc7486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "88c8ce4451b9d8e3219548b4d42a0ed11e4fca55b23fdf57acfe5383c6fc7486"
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
