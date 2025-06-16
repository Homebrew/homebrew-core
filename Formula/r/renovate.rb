class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.58.0.tgz"
  sha256 "43b9febbecc5b56d50efa6b96cb2fb3e3c1f3955e25a96eeebbf8416eac82af0"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc7f71588893094066c545ddb7658cb625b21b95a916bac9367978cda2752fc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73067dbd35f770793052d964acf9ce2a9edbd90d14658d6155d06616619b5091"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de97dd23fd4ec63e7d48481d78a7cc296a87ae67b65bfb400d348461407516e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09b689bb31ac0aa089896b93187eb51e8a71ed0b56a7697b7aa9e1053fe2010"
    sha256 cellar: :any_skip_relocation, ventura:       "382e833b33b4675f064d9bbddae355d6889281b0c900ce26f46c54a9efe1efcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2313d57c70e189c7cf9cc4af5881954f5ae54fd2304076070f4925bc37d5097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "809d917a65d82f575e406bfaa3493666ddec1bc1863ec7ae9cfdf1484c0ff0b3"
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
