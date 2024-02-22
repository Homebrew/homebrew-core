require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.210.0.tgz"
  sha256 "a2f98acea1d7d2bbc6c8831c2003367689b9920f63715c5378982e804e288b98"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "86bb81617175e19ec71b1ec5fd17026962e74b661c525359157750f7881878ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0deff1f3e49296d0588ba2c7f8a5df84c1d0043582e51b7d9d7bffbc8415a99e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6a4b3de56504e309a89b0d3f37aa693236966d507a8bbb2d608f8437295082"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce26630c7c5b80310b33c38e258e2a2735357d5c368eeb99fd8d39d838654f62"
    sha256 cellar: :any_skip_relocation, ventura:        "dd66af6ed901b9bb96b239b1cb2adb8ae042a7b80cdc8a02f12cff454a0e5a59"
    sha256 cellar: :any_skip_relocation, monterey:       "edb5a6fb7b073d5de9c8b3454d32f3cfb16de109c4861053d1b10e6c60fd9d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d13fc7c0ef99442175c0f16f86c6dd323355c861c95f1eb4ea53d2033e816dc0"
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
