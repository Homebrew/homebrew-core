class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.93.0.tgz"
  sha256 "98e2cf8325177c87574f1ea861ec04aaaadb41faed3afb37a5517545157d20d8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30ffc4ec7ab327de9382370aec3d047079d1c62d3796791eeaca682f39b66449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46641825462634bd1e5f59664e2445795871eee499ad3cb1d919c6fc439ce543"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15e55a9e19ea97d28948f136b91806aa133bdab356bb17c3d23628bbe299027e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9e7812cf8ee42b846d209232e0d4882f59689e1505aded421b08385c5651987"
    sha256 cellar: :any_skip_relocation, ventura:       "0cf7a4d1e2a559b427175b9960a066fd692efe6871de537fc94498c8572e2452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e007137f1f1a1ee27caa834e044335fc4157471a23ab3018d9626af2e224a29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "827c3784bd0de7c365daff9f2a85c9dd248c029fddf7032d5dd3c71b43b3aca3"
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
