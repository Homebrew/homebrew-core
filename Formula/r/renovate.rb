require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.42.0.tgz"
  sha256 "07c4ac0a4588443b47d33b43162774737d75b74092ecc6fa9638dfc87e068be6"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001bf98468cc277abafb1fa7e2d1688b39f38a3b9848d1bf9d4ceaf3b35716fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "584fdbd17bf9d368e9424dae377b73d6cadcf36f340626486db31a3c9b5c278d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7989d84cb511fbbbd2c138e89cb1044d3a58a2e620c4ca0e960359d07aabdadf"
    sha256 cellar: :any_skip_relocation, sonoma:         "a16c8f6df536f2a762e25961ff15a9f8314e327da84d18d8f4e48e8db12aac57"
    sha256 cellar: :any_skip_relocation, ventura:        "f4c0e4b12605f0c99f447dfed66c3b32f47cd34b8fa169e1ab062523d60da834"
    sha256 cellar: :any_skip_relocation, monterey:       "c09177e8c85c3c19378d88a70d9af8590bb7e8e1ec50b155fb816dfb8230cfeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39d67a18444bc5d1805f3fadd0e98bcf9411f77e6ce8a836eaa13a8bdbdb4dde"
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
