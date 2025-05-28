class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.33.0.tgz"
  sha256 "267267f67f3bdf32bffd2c3ab1e310d6d128e2cc5545386f3eae8398bd1a25f0"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2a889b98ceded998437fd70eef0bb1db96a32831a12a380917f2d0a85cd25ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1528027b92c48ad81febead4806ffbd651e7f20193457180a2e52dca482937a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "555688ba195e97f1116afc185bd50b30079b8a62fff26d6296c22b26e4a61220"
    sha256 cellar: :any_skip_relocation, sonoma:        "6565adaef7157c91c5da0aef1c4f97b56feded300268d42e7293ab296e325285"
    sha256 cellar: :any_skip_relocation, ventura:       "13b7d338fac663d13b69db3a8c52b6962a713e758a09503c765fa3a83b6bab40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "367d2f15573b909b47cf0036bec8bf90af9528a3bcec74afd84c5b97c6ed4259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83acd101ffbcc6ac148057d94ddf526e1ecd1f06c5e7f0f657438a3ae7dceb63"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
