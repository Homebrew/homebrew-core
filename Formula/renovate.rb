require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.115.0.tgz"
  sha256 "3fcd5eda6d635bf76e9935869df24c0653ed5b1d0213050c1df0754d7733f7af"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e847aacd2c2d688b22fee5c2570bcff6d043050e985389fb5c84df23f026e111"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a45720fdba37cc7b8beab5ba5de673b450cfb444c27c0326e9eaefd4437cda23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e65d28b369d5049a4a05085615529bc7b0d9fdaa7a61808129e60e69aa2808f"
    sha256 cellar: :any_skip_relocation, ventura:        "b57008555535ba3e28c5cc5c69452b1d70833b1ea1b186f0e39f36f7c32fea3f"
    sha256 cellar: :any_skip_relocation, monterey:       "9b0cb0a952d858c906c08130ac160ceea1ac9368155a35d5c2442ea5df969b6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "06586f2e29b77f9cb62bb2a178e94eaa5a56a87fe685cda0eb5c993de2f1a6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c1a7afa36aebc43ce52ee3e074d65e8d18a4f0ccaf1a192121ba3240fe095cc"
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
