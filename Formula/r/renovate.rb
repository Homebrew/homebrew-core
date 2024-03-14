require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.246.0.tgz"
  sha256 "d02ea69cfc15dc4f5c0fae2f91912003261a9ad3709ddbb724807514e3b3a13f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5814ce576b1d923a87ad2529fcf56f3a6c2e479dbc0fd0e39d0a6b2343bd4338"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f3ec1746e5b2d3eedcd79ca082088d884adbb6e0bc95cb9e66ab3eb2ee7ead3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8607d2a645ee35a1433fd5bbe7c3aa420625431932ecd3d5298d6d08e01b9ec7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bf5e976f5a1b5977ef4916b83a0e733a1e6ab6cc739321c2f78b661ea2a5344"
    sha256 cellar: :any_skip_relocation, ventura:        "70bb875bdd150619abf3a6cc0ed73bbeb622f666768b3254df6fc33a958f98a4"
    sha256 cellar: :any_skip_relocation, monterey:       "eb0d6c7ca677a409a90eb2d5d44118f68ed745355048b70a25a03b8cfdcec05d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff7b1c22cef4ae423cf6a72f732010f3e8b3c48ae1b1e6fa57755b78bef1a9eb"
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
