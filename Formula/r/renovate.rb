require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.420.0.tgz"
  sha256 "fafa57cfd9784546d302437f021a2f934529706e84209e065c7a66abef3e9c80"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f58427768ac22ff3e97e519410bdb4b1a7a35085f6779a69a10aeed1656e98d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41a1e7043d5cda079f3831a087906bc7e6c5d7f2824e65c7007fc0f1be225faa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b906960de77897815352d11381438a586b8961fabab85873b96c0d53f1bba6b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "29247419efc444529e81c0d849b214bd50bfe68f9292c6cd1b17c611188e1bad"
    sha256 cellar: :any_skip_relocation, ventura:        "be807b522ad99b09803db93230083e1c260bbaba41c801be9116dd6a1dda9e07"
    sha256 cellar: :any_skip_relocation, monterey:       "28245717f2dbe39b31a71f18203496c68f01184ce972b0f7c04b0e31e25fc251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66b99ed8b8f70e575fc7ef2634dbecb8784b66dfaa2fe88f9fda1edfbc8cc08a"
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
