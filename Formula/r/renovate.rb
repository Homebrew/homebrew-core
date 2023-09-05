require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.82.0.tgz"
  sha256 "4d02c2268de7f94b83a49257f3f3e2e5533700a5040d60d84df38b64e5d79acd"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6830274dbf845bf945fb1b9174b06dd3bb706e8fbede62cdefd29266611d773e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b948a68c0d699dce48676445fd017948ab058d54d62973600f243d5e0ab256"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b5a66dfd2924eec02edd76bc41cbcf1e8ce77c70856410a5b3e7bd6ac40268e"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f7de2f935dfab72becbc29ebd684d88e32ce51bede61de4a7a2cd172dcb9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "0cabb13db972c154dcbeb9fb9695ed6c1cd81a576beb572b60ee0af2c51c7cc3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f60f2f2af82ea00f70fe3e0ff53b8b16737b1b39179f6d6ccc9a7a54e95bdf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e64d321ec1b321603a48fbeacd01ca1573b0ac3982becb6cc79fa91a59aa8367"
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
