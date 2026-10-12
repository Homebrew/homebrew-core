class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.149.0.tgz"
  sha256 "45e35903de13efe148c12784a03a5e43b460a9c2acce64a3125b02317e70fcdd"
  license "AGPL-3.0-only"

  # livecheck needs to surface multiple versions for version throttling but
  # there are thousands of renovate releases on npm. The package page showing
  # versions is several MB in size (and the registry response is 10x that),
  # so curl can time out before the response finishes. This checks releases on
  # GitHub as a workaround, as it provides information on multiple versions
  # but has a much smaller size.
  livecheck do
    url :homepage
    strategy :github_releases
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b26406df0a757cfa39f5d2db0bb9d509c42f8068c6a54ad9f766efb1e4cec1c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b26406df0a757cfa39f5d2db0bb9d509c42f8068c6a54ad9f766efb1e4cec1c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b26406df0a757cfa39f5d2db0bb9d509c42f8068c6a54ad9f766efb1e4cec1c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "75387d1ce4005316101e3d459cfcf46351d2bb64e213053e10eea4151c6804b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "75387d1ce4005316101e3d459cfcf46351d2bb64e213053e10eea4151c6804b4"
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
