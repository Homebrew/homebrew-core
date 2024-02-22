require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.210.0.tgz"
  sha256 "a2f98acea1d7d2bbc6c8831c2003367689b9920f63715c5378982e804e288b98"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea6b65ac821ef4cbe38d0cf1c46b02a12ac36b6c282586990fcbbe410786d522"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "833a82f39f737ec995535d4a517b161474236e7b6b796a018b35d38d0dd62b27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "463d2cdfee39e226ec800b76e1fb675c4aad866ab2f1abae7d2c65d5d8a386bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "142797f4ce55e325f84569b1998f207fdfb7d6e9cceb7a168a470ce8ee18a0f6"
    sha256 cellar: :any_skip_relocation, ventura:        "0de03a4484385a6ff1b9b24697af4c59d5a1e893e1255ad194040bcddf2c9195"
    sha256 cellar: :any_skip_relocation, monterey:       "52aaa00951b6755e202eb9d6dc2417f299c57a4328dbb6386c222e6ce68be2cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166f3986e6a75cdf8a0ea0c42d59e49d0e22bf94f1bd08ee9d97ad71daa48144"
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
