class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.5.0.tgz"
  sha256 "c7d109bea618ae48cb698eefed68c11d3e9eea57bd5b0248d094e3c1e7276e50"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a033ee98c8966545485b667a720a548c03653272f23901433b7a8a8b06153c43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5857a78ae5987f4b43887315ba4241edea728b61bac894ec828ad0145478e7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b016e8938dcc672e3ba55a054dbc338e0ce8c0dac8feb5be465ab90179f4627"
    sha256 cellar: :any_skip_relocation, sonoma:        "2aff7688fe0403d7931b23294b400507bacaaa7aeba33f93a70ad0a1e6bda531"
    sha256 cellar: :any_skip_relocation, ventura:       "8504bcff2b504ccfcedd9c31f38a332f18eae641d22974e171fedbfed2498661"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34c3ad4b3f150ce2f93be86d3c322d70738a898d9ae8fa2d585a1d1e5a293b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9743ad664a790b318bf8e5db40e5538a3a04026afdde6e12aeb31cc2976a5fe"
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
