require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.232.0.tgz"
  sha256 "72e979e65f7f4c9698b384647ca285dfd1246944ed7576d7dee3edef888099ee"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a72f37652235f17966a353e8948781ca2fb19b572e03691cfb3e5be82c3f4bc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3458cb066b50dcf30da02cb76cc2459c4576c44c0ad78d6c042729607a85b377"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "829c45551bee8b573215bc711f937e2ca553d5df5ea07e03696cc22c2ebb034d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1665591b149dd1c9ba5433256f05866611bdde342df2f56b722053a7d3e46846"
    sha256 cellar: :any_skip_relocation, ventura:        "66e1cf1c54cd3c89e926cb097831a49e8c12e8df065f47fbca4d93b653cd1cd0"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4592f0633463f7bacccb6df36e9ace2e5655306f3e1eb71eda54f3b820dc4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82b452c8498d2d0b9eec52d5a5d999224d4e04ffbfde3b69d580ccc431a0e95f"
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
