class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.128.0.tgz"
  sha256 "7bd716c822ecf353e2a878d291304cc00fcf46f4b93df64df364dc92e2026d2b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e55683f11bd2b41321ff847d0167b56272328ecd58f476f73f535aaad01a3c98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb8eff11399cb8208eda5658cc2da21b4e1449c50c1dec48ca92be50398592b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92e7688a5e2897c436d9add25c1f9759c1beb0e57a758568809ccbcad824e7ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa70fe6d4486fd989fa6569e6773b881ec00ccc65c918595f2d00b326caf30d8"
    sha256 cellar: :any_skip_relocation, ventura:       "41833dd4eb6f165551c1a304924b15fd2bb6c5023cb47b1db601391f791fac30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9cccffd81b1489aaacacd967e89875dba00bdf812bbc2389ac8f058d6ee6306"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
