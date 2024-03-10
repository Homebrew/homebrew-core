require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.234.0.tgz"
  sha256 "25b928b52fea5a3b1ef3c8a15359c324a1836c289117a685c176d7aae1d0405c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b82f571fb68940ca94bfce120e5d37b53f9389bfb1514080bd538c45eccfb3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34bb497c7894d41ae76f0e78c965381ed39c851f855678b70bfe616102db8381"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e4f176f2ec361e095d0784e521df093f0bdb1e7c74f54a8fb6e4cf0cb4a9f5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "298d3cbbcdcd1dd01201ad1ff07e2caebbaacc8b5ef8d10cab8e09be69ecf07b"
    sha256 cellar: :any_skip_relocation, ventura:        "d3807709abf6921decc78f1b76a3c254fa542ac01a0367e350c8420a1edeb7e5"
    sha256 cellar: :any_skip_relocation, monterey:       "ca16b03737a8e72389ef8b5b15b3da8aafe4a50d3b60e2ddf9cdae4dee7276c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f988db12a10a6da20462dd8e8a8ee8b093813d8631f3105c7846b94a2da25c"
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
