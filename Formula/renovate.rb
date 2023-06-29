require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.144.0.tgz"
  sha256 "ef3e31239ca35a6fcaf777b3525a14da7f471ec301b4dfa5e695c0c354b1e822"
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
    sha256                               arm64_ventura:  "bd309c3557e870807405c7a99d3b5cf7a70be2803aea04d8b2007a57fa122ce3"
    sha256                               arm64_monterey: "50f2dedfcf80ce738f80a5e5adf34b1469a40c1661cda2907c4a05253eac9707"
    sha256                               arm64_big_sur:  "5e457021c0469d6cc44dcf7a3390db083b048697ce2a2fbebd298176082e67ea"
    sha256 cellar: :any_skip_relocation, ventura:        "68b4fd70148ddb1ad29ee85e929e3029f56b2e57cb3a17cb77965c25dab96d4d"
    sha256 cellar: :any_skip_relocation, monterey:       "5313736f35d2587a76ed8aab9228621d24b3ec03608318ddfdbd0ad6bf091d02"
    sha256 cellar: :any_skip_relocation, big_sur:        "a94265c78f73633a7f2df4622e704e46b915c5d4538ac3773df295a57ec0314e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9bb2b7b809c27e5b674ef8a534d55a3e852e799b308bff9dd9f0b85e4da1193"
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
