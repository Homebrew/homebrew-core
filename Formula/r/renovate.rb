class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.185.0.tgz"
  sha256 "2cf2250e5723fcdafb24d013c1f47e6213a45c9359abf9a0e3a2a5cac8c439de"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7928a1b868e4b23733abc4ff5f35a760988061b9cf9d04707724cbfa4aa4c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4c381f5496750cd83470a428af6856ccb6607c19e16c6f351845e7b3a32e79d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12ed989ba1d312063deca13ea847d36ae089fb11dc9a9b9d3851652fa8899b7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd18b15371dbac4ca781dd904f5335f5f16ead555de9cd673a677fcc258e90fa"
    sha256 cellar: :any_skip_relocation, ventura:       "604cf2e6bbbb0330af3b21d1a78fcc8bbe9d1afaeec2aab351b855098a230ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639aaf3e079297f08b49650f2c23d368fcd1fda6e25c380a46e633584cfc78b5"
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
