class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.96.0.tgz"
  sha256 "d12d9bd5c834ec2598745c7dc040c5d5ad1406d1d90b7ad253c2abec5f2a7c26"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5be577abf3697a8c63db4415cb2d15af5733c428948337cf05c73184e8755cff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff376c2579f258e4780f01ce678e19fb192fc8e6854186c295220e756d5a260"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "adcdc916873a37e102f191fed56eb13db520131191974b2ffb48330fe81abf20"
    sha256 cellar: :any_skip_relocation, sonoma:        "c22f0493b4958c3232048a92daababf3d6470df06aa214ac0aaf133ace0db1fc"
    sha256 cellar: :any_skip_relocation, ventura:       "08e480a3e27fd1e83af4ed39b758385110fb71dafce7bbf158a6643a9abd223b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bcddb15b23640942d74b9e3b2d0f381eb5d489878ac64f9d07f394a6da90fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4138c7d1d8d1d087e0f36d0b899385b574307e9502db8e033aef80456f57b6ca"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
