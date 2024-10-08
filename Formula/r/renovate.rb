class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.111.0.tgz"
  sha256 "ef4926a28867743410d9b71f9d6768d9848bcc87fe38ded71389a4a758e9bc26"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fbbaff7b1b9bee8e04dbd4febc03175626d2254eefff3b672e5fff97e1a7327"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ed253ac5c3cc7f3d82a06ede2d83606260b5fe0d9871c473431b51f5087ebe4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dea2f39917e2d04286cc9eb46e81296809474deb2b1b625e991dda43c485dda3"
    sha256 cellar: :any_skip_relocation, sonoma:        "02bbcd50000351fbf60984e3a371fed849cfd03abedd690dd466bf1adcb4b072"
    sha256 cellar: :any_skip_relocation, ventura:       "2c3e4cecd42b962fb2d0c97cb1428fad2df1c461bd860903d4e476f2cf0edbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "684469edff5cb2b88e0ad71edbc0660ca47b03aea44ce050098eebc092d2ac35"
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
