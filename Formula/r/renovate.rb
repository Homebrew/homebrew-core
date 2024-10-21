class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.129.0.tgz"
  sha256 "3bc148871211b3e3f04b930999f3872b493e47d5a6c215229beecf7e8558b4b3"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8c8f4a03dbf5556638964554bfffd1a9bc58fc72318c9d872338496cfb18f8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f0568611481872a162697ddc660ae971be1a21eeceedeb77945c4e797c7504b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f46e77a6ba751374203678e6f87d8ab07d48d356787fe79979ce79390e230e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "b28c854a45c8e9a28d04eb8621630be816acb65f67a3119b0d4fe81e32f2435e"
    sha256 cellar: :any_skip_relocation, ventura:       "29c48842c2e886231f94a4bfb5f788b7f4c9dcbb046c2d5cddde72e2f3249fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0fa3d118220a009431e15bc7ea3ca3c7bc0680f17b82e7864a9793b362c23a4"
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
