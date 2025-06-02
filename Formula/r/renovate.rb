class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.37.0.tgz"
  sha256 "de080d1b1c2f9f6277ac98bf47ac6f2a2d9422dbf11b76bfae9611bb413c5d15"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d81809ab99388c96425867f7f86968ce4a57316616795de9432babacb2e29e33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df2800d24b89118d4be77e7de636c4d645801b7f57f03d30531ec2bed19c03e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c046515d2f78ccf9b2f417634b5d6f367011f82832845d472745f5ba81d31cfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebf4c4fe58af8ff1fc59fb4c359692e48f61d76f9201dbd0b12141b7ac174121"
    sha256 cellar: :any_skip_relocation, ventura:       "30093d0afac33bf7a310a4d184adba9b814398366edcccd99b32750a7205f554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33fa85d123fb4a136f948895c16816f04adecfabfa49e3d56bdc7b0858dc08e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef654a60358e44886c0b71b8dc9640a9aa523f0745106e5f5ca89267654bcf50"
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
