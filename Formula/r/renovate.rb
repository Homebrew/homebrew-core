class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-44.133.0.tgz"
  sha256 "757daa78b3674c7e258addfea052bd9c4a7d51785d7179f3dc48d06468c30ab3"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e54b98865cc20706e165d83ed82b8677449d043094e5d1a148a92856ea9c8ba6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e54b98865cc20706e165d83ed82b8677449d043094e5d1a148a92856ea9c8ba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e54b98865cc20706e165d83ed82b8677449d043094e5d1a148a92856ea9c8ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06a4e3189a787f108faa6245c0357731d5a759961a7f69c8429b1b2cefc6947d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "06a4e3189a787f108faa6245c0357731d5a759961a7f69c8429b1b2cefc6947d"
  end

  depends_on "node@24"

  uses_from_macos "git", since: :monterey # needs git >= 2.33.0 (Apple Git-136)

  def install
    # TODO: Remove when Yarn releases an npm-compatible core package, https://github.com/yarnpkg/berry/issues/7281
    inreplace "package.json", '"@yarnpkg/core": "4.9.2"', '"@yarnpkg/core": "4.9.1"'

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Renovate filters child env vars, so Homebrew's git shim cannot run.
    ENV.remove "PATH", HOMEBREW_SHIMS_PATH/"shared"
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
