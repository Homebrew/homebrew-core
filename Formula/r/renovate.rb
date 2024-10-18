class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.127.0.tgz"
  sha256 "dc9a9a178c222513069686e52ac5bca0e69dc3aaee84098e67a1a1519b563167"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8bc3ea35bb626c03cb4ad8ed21da58a92e7a605d2893bbd48d9b5ccbc075146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f7dd99ef60a965983b00da78596c7ca03e00f0ab2feb83294c2a2ea38e66ef8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b419049ec32ae7a1822d31a65966592f750e995d03a69c528fc57842282a8938"
    sha256 cellar: :any_skip_relocation, sonoma:        "f994ff136dd40b7ac3bca26cec6d13662a9f5b68abbdab3457bf557508e9c7b9"
    sha256 cellar: :any_skip_relocation, ventura:       "878b005ecae0c69437d7f7fde1af6f9dbcd2ea28333279263c540624da4e2861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9510af22c5abba858b7b4e7d3126908d82664c6fae24438d6164f4251b3f97a"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
