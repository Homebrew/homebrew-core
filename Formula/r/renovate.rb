class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.191.0.tgz"
  sha256 "4f9114e838b582d39555c1d303d3031bde79f2d0e32ea0848bdab2d3969b99f1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ae90b6a992bb671d8b134a943db28f8e2bb288ae52140a4888d79ae4a17ca1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e737e704857eb765447ff7a488cf29e251d805a0dc44c7ae5dbb15868c69f661"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bc2045e6e8ebde4b6dea61ca266798d1bd93ed97e8de2459d9d2250b9b03a28"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b617da36b44bfdf30523c85fd9a545e9ebbf5bcbf3dc75a3d393d4be0f36338"
    sha256 cellar: :any_skip_relocation, ventura:       "d091d9dacc49d3b640cff402889d47101c835467b4b895ace9eb21e7125cc65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ce01c5774a5350ca364452036f7b1d916b190b2d26b9969040851a651317c88"
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
