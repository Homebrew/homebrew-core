require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.397.0.tgz"
  sha256 "5cc70667cc4af3c2d393141ba71ebd316eaeed9b875ddd8f0bc660b0f313b2eb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "001d831f751026966b9f385bdf74ecf3e6cc7a2ca3f408a194d5795ab1fbf089"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4248a1dcc9532fa1090406c4e93fb400013a98624de423a43e39fce848bbdd76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fcb7f6c44c691c133e9639e7d3f69eb8b307506e1618973c985f6f32b7924f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a53aff02556a3c60cc4ded323942ccc5b24b5a37687cbd8ed63879b293d64db"
    sha256 cellar: :any_skip_relocation, ventura:        "06ac1839c59f0b7c0a618ba43765850d22870103a3f0ebdf0f23afbe2c8a8327"
    sha256 cellar: :any_skip_relocation, monterey:       "18e4eff1d32beb2860d754f62b3f8bf53637356ac1c58a124ad8f86055bc8f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73ff2500ec94621f001c7c20143b7a39868d63973ad2e998bdc9c45db4cfd46f"
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
