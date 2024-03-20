require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.261.0.tgz"
  sha256 "2bad6d716416ae621fe95b6ccc4db81923f29e52a7b97d0fb2dbdb8adf624abb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7f14b3bf0801cf538e78a91e7d783346768643d9f7199eb98beedd3915324c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfd4c62440cd359f1146003f1d6ef3d953b0c8a37efd1bddea33d67da76c1506"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f957e7087452aaf73b37c090cebbe0f3ae2f308bf7744223baf03f6e90852f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fef036db572573ec1880e459f8d1315f9c4510950037cff7cf50804b2993454"
    sha256 cellar: :any_skip_relocation, ventura:        "52f38f0ba9da1e8f400d4b2967633b0a1733ef8a45af98442cdbd318f21a815b"
    sha256 cellar: :any_skip_relocation, monterey:       "b38e2e600525bb6314d3daad66d14fd52b61f57757b95db92abf45144140726b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e187bdfc491201ba41b392946773c301a4347b21aaffaea163364ac84d2dc03c"
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
