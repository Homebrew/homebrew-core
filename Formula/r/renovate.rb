require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.256.0.tgz"
  sha256 "879cc02892a4fc3b626ee00d7d4ebd447feb75e3f12343b7d3869ca3c8d936c2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56552c734833edb6960b6757074b64e210e14d349ce5a811ad06623bd334d009"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aa8060a6f8010f5f84c13fe67becab3ba063da9d0cb2d2a89a81cc8da594e63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "23e9a71ac8a033f736efb5d6bc7c2606408e0bf0306c480eb5de58b4ea211729"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd670a9504c66d0f1930c10b06162e4258ded7caee716f66c7ccdfcd89aca0fd"
    sha256 cellar: :any_skip_relocation, ventura:        "316df3a965c00f9dae8e59ff486f849b8d3d0fd22102fc3bf0089250169b4ff4"
    sha256 cellar: :any_skip_relocation, monterey:       "5cede85f7c368df6d6ec128d1367872f28c987c43fcda41611ad5efa194f58f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b75bbb4a3b61674292676ac619e9bcacd6a22d5425d18afadee0c1f29fd51508"
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
