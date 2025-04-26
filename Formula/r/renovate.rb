class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.259.0.tgz"
  sha256 "af446c2500eb2b9f050f6eeb43f727f2a405c1dc002c1dfa4eef02ad5e641177"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea90b4f4c82c32128e7ffcb624441af655b9b932d3a6064946ace0895184337c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8600be3c20f083657101d6f394b5c06ba808b7e250c2b5f7e3151b8fecc4a2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99d50851b0fb91840a07f0f541259d02ad06a05c130608515484a80642e7acd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c80b6ba4278a44007854cac0dc43ab0ce7f311e9d2d262c6e7f6ee3964b635"
    sha256 cellar: :any_skip_relocation, ventura:       "f4637606e06734101ed1d64de8e6b273d347aa7b42efc3cf8ded8564b3393085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36e7f34ab0d256ade52b947291d017d44a1271216672c088446a55c02471cd87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e942de3d3106467447693c043448a281fc8662726de7dc7cb9ea5197e5828b6"
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
