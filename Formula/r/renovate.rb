require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.263.0.tgz"
  sha256 "60acd6a91f54a191d8f9814554585bf431d4cef1abea21731e3f3a9da9f4c26f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "827a9111c55c679e963d6c75205b0dcce18df4a5e822a77e18290f1a2eb3c921"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "171203c9d69aab805f2cba66a78dac1006db7a4217087a2e55d29675a131c098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19e5562d7c36bc26ddd56e81a5abaad0adc9a6337dea76f2fa573346687591b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5606cf02db0038792102763d472ebb0add15bba998fd48123f1666e2314a24be"
    sha256 cellar: :any_skip_relocation, ventura:        "3cd8e8528e1f77b20c584cea31b0eecd9cd31d36a5a6830c603293c40a21523d"
    sha256 cellar: :any_skip_relocation, monterey:       "1f5ff350a85948c8ccd3c6946ff53676366bb49290ea0bdd493b20ed41e57be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a64262146cf124fac54bce0abdb30a26270959a3a316f7eca91bbd182ccd5f2"
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
