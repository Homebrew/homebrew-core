require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.255.0.tgz"
  sha256 "e6189475f7d147a2163bd179f87804fa524e30c096cf60ab019a2c7a84b1ea87"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a8eeb1c3a2c8867043e95b0a6cbe852a8d51b293d1cc897163d2056f72af4f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3f048b3d6dd9f8a2121a25ff6185698f5dc47a32791207a6933ebcc82ad2d0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4caf2603789d010b0a818d7bebaea6d230c6726c0ddbd70bcd0eb73ed7dd322d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e30fdd235bc55fa0fdd294f5b7d2e8b46082fb28a20ef5227a5c11f6f0af7eee"
    sha256 cellar: :any_skip_relocation, ventura:        "c07cceaccf01dac5eee782066dba2950fe50a5edb8cdc252706123118db642ee"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd8483693be05bf6ba7e8f366ed68f8e343549aad426e8c038f369f5b32f25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1317646a05225b0eb044387ad7c12ed717a22d43d724c1f12dd6db6237e630d"
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
