class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.32.0.tgz"
  sha256 "fcf1f276d3f975d6f7233c79fa8de02c18bc4b77e336b799a0b98e747e61fa33"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31e12dcc6415e71b23368984fe40f345e907e49d2be7a8792a152d2af89afe21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87707b452a7670501ee28ec5302d4ba6f8acc73b3b856366e8c29b77b7424184"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f82860051b09e810b6a63f1d5bbe33fe1c4e68d44bb734ec7679a4d2a8a6b911"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a288fb15da3dc59f008bb1ff232373c8c35bb25a8361c9e831ca224d9f0ec6"
    sha256 cellar: :any_skip_relocation, ventura:       "2f15b78e118245b19e285a2b55190220ad3cbd5c351f99d8e2cc7e754dad6038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63e75345caa7041288dd2ac8f377732d772353ea7018b75ebe919868828eba92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74b350c313db3b95a2bdd749658c24577ffe4e63c3aa2c7783c20eca70911c2"
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
