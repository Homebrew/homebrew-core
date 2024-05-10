require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.354.0.tgz"
  sha256 "f6b0639d6cb5a6994f9d509b9c5857de003a05553ce721d1c92b61b7ddd05887"
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
    sha256                               arm64_sonoma:   "1c3b17af1dd1587c828af33a89e1ede664bf7982b39b6b51759832b9bfe80f28"
    sha256                               arm64_ventura:  "a8107f78c6747f1bb36ccc7c4aac16c6b43b8bbff30a4cd5f9f132f6aad21b1e"
    sha256                               arm64_monterey: "b70176ab29b9b5e6f55945bcf699bb53bbb535133eb916259b83d6d95ba51a61"
    sha256                               sonoma:         "a64ea15f0933aadbd41c3842834151ca7919b5d5e8c8f40a6037b4279cc6f58d"
    sha256                               ventura:        "e3053d0537d5ab47d0bdf3390516f473b9e416ac6b5384a1979ed14c5d3b844b"
    sha256                               monterey:       "86e847ca23f3420a1585db239f889f20feee0494f3db8bc91fbed367e73a40ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1676e4ca51f2be3cadf34bd1b62c59ec7aa965ce6ebc77e290bc26d78b5195f6"
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
