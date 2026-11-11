class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.225.2.tgz"
  sha256 "81904589494fc7a228a8cbc3cfa73083da7a5d2d1144df495c4f9815c0bffb24"
  license "AGPL-3.0-only"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e19fdf17cd19f8c01da13b053ff1d0fc7aa859e42c6d389803bec046d68f802b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e19fdf17cd19f8c01da13b053ff1d0fc7aa859e42c6d389803bec046d68f802b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e19fdf17cd19f8c01da13b053ff1d0fc7aa859e42c6d389803bec046d68f802b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "65d002a19f4a141a06a3dc90b83c73d1191abd626038b0a8ae3e7519be13337f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "65d002a19f4a141a06a3dc90b83c73d1191abd626038b0a8ae3e7519be13337f"
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
