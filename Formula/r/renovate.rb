class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.75.0.tgz"
  sha256 "521a7692b1cf1453c5b4540408d53eb5a8a9f4c3f8c87d566dd0ecaf7c1ff59e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cc3c997dbb917281a18b0d8d627640dbbf4024f6a1fed43871305d8dc9576c56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fca32623a89886ae29d1c4fb0909ac298600c3444eac0e2720b27c45a7daddb0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c358061e7ce30ca55ad9bd2b5ac053f0a9fd247e949343b2a285dfb9cb2bfa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2905722d78a9cbd0bda0d88bded5e978bca38d4cd72015f826a83c2cea4699a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f415fb5fee8ae91bdff13009ac31778af029b2d5f88fe29906b394566aec95b"
    sha256 cellar: :any_skip_relocation, ventura:        "79b3342276f5f0ededc1563b3422a02732eb18d7389690f72df4cd08554c46a3"
    sha256 cellar: :any_skip_relocation, monterey:       "f52df15c85f346675a29e2eef6073cf164a087c11faf009b26989e43f093e249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dee74808857db5201b1453f7303299f6903bc798a800590acea618733717f70"
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
