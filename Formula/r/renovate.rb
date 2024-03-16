require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.250.0.tgz"
  sha256 "fb841b5d0a83e3a6fb598bf57d15271cfebb615791b63eb29d4d169c6182ee38"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d37e2e9794fd8f83c172aa0d8164eb88b648640fb9ab5babca2b75c7062c573c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d3c77ec01609ed41080c8a908dafa4306f1d03fc4fbeb0bea90c797a46bd192"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e93471e31ef5245cfdbd0b4e124ad7987136b6760955e69a69e4aaa0aab56ec4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c03f36dbcf08cbfb441721c3b569916c6a8d33015c4d97c4300fc695a1e1791"
    sha256 cellar: :any_skip_relocation, ventura:        "57c7eb612cf32fe326830517016be318fecdffbad3838103d4284688168210b3"
    sha256 cellar: :any_skip_relocation, monterey:       "837c699f4942184018058afb39d106a7d03bd96c6e0c5f97fd86cf02bc2381f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b801d5d5e5f358dd614e9a9fc176e19dfd0ffdcc0f2c7e7454c2dd4f06994d0e"
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
