require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.239.0.tgz"
  sha256 "983855093e8663bc4e1f71b3ae6df2b38308dd4c5394831af99b1e9573af8fb3"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e71b2eb9ce353dfbbbe4bddb99a186b445cdc06f0d4e58ed842bbea97f6b3065"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8f6fd669752f193ea8e6845b8a8231367340f147764f59484ff6bea6162837c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ebb1763fdccefd82c7a5638b887aabf401e4a66d140d4dcc1a943727740a76e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1a1be49be57ed0a46118abe161e30eafa4b6ff21486112e5548b4d23e49083e"
    sha256 cellar: :any_skip_relocation, ventura:        "1df2c2082f9ada7182061adbb187e8211214f79f2690d73bd030dee5cde851ea"
    sha256 cellar: :any_skip_relocation, monterey:       "05a835469b1e11d187698b3ea5f16efec40b03a2d192a0e03124170d4f54b5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5367143cf027dca8fd15b940e0a8cd857bbfc7cbf64237bf427282a15e74de"
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
