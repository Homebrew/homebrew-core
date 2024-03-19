require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.258.0.tgz"
  sha256 "c0b75e7236ad6e9930589947a696dc783ebe36863a929322aae46b930765348e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a902e1cbae840963e17a208627695670df2e7228c7eda0d330d52901b7b437b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96d6b15ebce190e7a533ce52b2a94f23237939bbdb9ca0946381d9225276e9c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a494301801d86f16c6f9abb13726fc6e95e7a17eae30fba63d17677d851ce32e"
    sha256 cellar: :any_skip_relocation, sonoma:         "21d4d2af5f3cb4c086c2c71d823367ffe378ade785a3c69c6df9054734b39830"
    sha256 cellar: :any_skip_relocation, ventura:        "05a0f8e6cfd093b5bbbb570f7990dab0d239f4614cdcd3c12174c299dc569b43"
    sha256 cellar: :any_skip_relocation, monterey:       "bc4359b477b1300372ec126c3edf21cdd85d6947a374df95e9bb36f1f7f46e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19c5938de6489ad0f37c2840425468dce7149ede0dd50a68a953dbd6cfdc19ec"
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
