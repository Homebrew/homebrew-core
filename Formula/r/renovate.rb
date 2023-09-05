require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.81.0.tgz"
  sha256 "a77aa7f9957bff42c836c0ddcbf9ff03b95e2e37f9796bba678fd29712e637e6"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17e98306b80401f5315b7e6ff43846ea9f92cf237d26111dc10b826fce74f311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6c711c1783e2d4371ac497844fdf8ceb4cb765d3136f27227b7cf57207e74b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e41e8c50e228dd15af1057ec74bb0114dc7f816bceb04853576cf04a0bf70fe4"
    sha256 cellar: :any_skip_relocation, ventura:        "d18d27da372a3da301eba674330239c795b6a49f159f1c8118ab1c32e19ed8b9"
    sha256 cellar: :any_skip_relocation, monterey:       "c1e690b860fda18a9464eeb98302c759f7f6165364ea15a016bdb283d52e65de"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25efa38063aa9daa020c86d78c095dc7f9c08068867900129f9b473f341aaf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5998bbc178f282e1dc79db059509ca2da50a37bf95a1658d429eca768154e10"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
