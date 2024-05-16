require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.364.0.tgz"
  sha256 "fecd2e73343674a014fd422bb6830824e53fc2b3d8eeb0347b504962dab19fbf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f8b11572f04cf0a5d2abc7a8a722903ffb3c09a09245dad473190b3d42bfbd20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "607fedcdd81e1162aa2212ff38069095a948582c16648f37a053f1e15f1963ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "077785488cc51e7d8a0cf1f91cdd3cb3c91f60f304a72fb77a4454168afea41a"
    sha256                               sonoma:         "2a7642eb02c33fd15a0b2ed9f35f6daff2a3714d2d3251d557869c7c2cde6e5c"
    sha256                               ventura:        "cf35c623dcf744587c2aa941bf6efa8ddab535cb0fe4a1d1bb2437a5eeac5f21"
    sha256                               monterey:       "7262ee21ec4d20f3f13a9e067b8b87a3ceb26c6f778e77117ad80bea00f2ed1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c11b4ca271e4948c2423b9496b2417a47563a933b2f126db20122d508f9bb2"
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
