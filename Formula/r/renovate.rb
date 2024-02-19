require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.198.0.tgz"
  sha256 "83d2648bda79d13cbc2c08f45034c8800ddcc327d621c07fb1e067d26b5b581e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7091fb25aecfa07bfe9affff97c983fdd75ed6f424b57bc637830c5b3f3dfa3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47abe3620988bc8cda0f32672b8a9f696a2e8918cb04efbe5efe7d720074442a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b5e6d6dbcf273add9239b0ceb4287e3b70ec881a83e784260d8f0c8c95ce4be"
    sha256 cellar: :any_skip_relocation, sonoma:         "c817ee9daac33a750f5ba8c678ffb214240bf88c2457c0bd1a40211470a8b33e"
    sha256 cellar: :any_skip_relocation, ventura:        "0ee508d3ff82cf3a2a6e87ea0209211d866b2c5b1fb88cd9d753a242c490cca6"
    sha256 cellar: :any_skip_relocation, monterey:       "56076770e215b233909ed14689317243b5dfef0353b21e8cb725f8732b2a9214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "654503bb0150c32547b74870339508b871816b51a4f469d4848aa4cbf2e9667f"
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
