class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.124.0.tgz"
  sha256 "02ffe52f39280dc14c1446567e9f37530a9bf7978cce750bd689d0c70386a41d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76c45d6d0f06c3173b1d658a2c0ac86b3a011e4fae606dfc7487726d909c7383"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1446d312b2f0378076fd03f480d093c3f9efc3c56a5ae0c1090ceb8a3a4415b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2889f6bf052e32aa4fe7fa2991790a8782aa686ff1458bb0a24764a9070aadfb"
    sha256 cellar: :any_skip_relocation, sonoma:        "71c10986f74ddd4ccd636e9de4b30b9698a905bb196fd407b49144e7d29e83b0"
    sha256 cellar: :any_skip_relocation, ventura:       "7cd42fa878de6ffe57b978459aa894b1261cf4aec836d33786080080bd6f86a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d188f43d3063aecd1bd0c57e264a0e14725e30a7bf6b3bc4816e70ea5850dfa7"
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
