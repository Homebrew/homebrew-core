require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.334.0.tgz"
  sha256 "e2373885a9a8ffa6ac142a7fb2771b88eeb0c85d6f2edd77abbb9c82f70755ba"
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
    sha256                               arm64_sonoma:   "3a6407424d3665b65a3c2ce6fd72451294249d4c34f9c765b550ee75ab5aa6d0"
    sha256                               arm64_ventura:  "8c2d90706eb07f42411452a23a42a25daacd7ed5b81021b3ced88f93b58b1741"
    sha256                               arm64_monterey: "b395f33a6d5430d3cd44aa289b9e3e868eb1d8239ed82847c329a1dc5a33c158"
    sha256                               sonoma:         "b1b96e7ba25235dfd39b3466179cae6dd0d752870af05ffaa2a1f92b115f63b0"
    sha256                               ventura:        "7f3e04495eeb02fff75435a5a30ffbe140d7930571bbde2c040b21d6a1155b4a"
    sha256                               monterey:       "bcfd18e39ec5d6d1c4c24da46d0d0ba3db10847e37e94ed1837b6881e1692d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9abe5f03e36b9e96ffe64cc9461ed09318ac5728fc5c338518950f7f5cf7b9ed"
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
