require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.301.0.tgz"
  sha256 "19697f17f63f6152da9a18c16e604f97544606178a0ba55e40d48eb9825b2c96"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64362bed082ef2a05de4f026794cbad07357db4f11bbae91dba92e12dc357f07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f4b68e95f1757e57ec60b8420a640d8aa41b415985c7b8b636df15d27800dd4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fbfe7932f65c190f665896216d293d165705e978d7d7729e327d72995d8b466"
    sha256 cellar: :any_skip_relocation, sonoma:         "0dff0201941e6bf04da6ba9e09172e7878506ba1825f9382887f858486a85957"
    sha256 cellar: :any_skip_relocation, ventura:        "75fb3ea1c535e7f0497f813dc7f0b969602bd788879347e41656ab0d7ca1490d"
    sha256 cellar: :any_skip_relocation, monterey:       "72913d612ac29c31f0b9045170bb5c44b9057be2e75991f5b3d1685921008aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1044b32794aacddff784c5515aed8d4b3235356b4a3d63bcd3f0da1af471b11"
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
