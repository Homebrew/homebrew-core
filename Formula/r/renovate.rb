require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.231.0.tgz"
  sha256 "8aa3eccb28f6f666f34c2a028a2e2311bf7a5dc88565254d94fab7bbc25a95dd"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001089127939a9aed8170ac22c5fa3b441a1cc0103408d07dc46bca5cd6e1fc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f610f8ab7d1fd0cc9797464e9cb5569796a7ad6febe813076ff233c3d459fe9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16d08a397caee0c6bfdfed79d1ce047b4fbeed522b09cc7c549f2d8835d1dfbf"
    sha256 cellar: :any_skip_relocation, sonoma:         "3cee2ee695dc26c3950e20a1d4c54c6f18ad7c4f24d9fef5fb12f04a95da99bd"
    sha256 cellar: :any_skip_relocation, ventura:        "39b3c90a06c895b41bf6347f4661aaa04f3a9350f5a47d94c48c1a1438fbd4ba"
    sha256 cellar: :any_skip_relocation, monterey:       "3fd324b692d0cb33b1cb0f65538e34e23b9051a716cebde3a9cf5d1751319525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a654277053a29a7640eaf3de9d7a857056664452168ba10887b018a92e7b2a"
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
