class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.256.0.tgz"
  sha256 "b0df833c9eb2fa9edd1fd91de6fb855cdbd70cbaa79e068fab9d5b847cd57020"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "688b2da702560e4a9624618d25877da1957eb3631b4135c471f6b718392d4e7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a450a22f18bc9a2fd6dd30777f3ea28b42c463fd371399f5cf8948e9bec06b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "467636b94d79e0b96dceeec5521c31b25282959b52aa86c2a80b49f783333224"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6d592a86b3f830b3110a85e3669c2c67ffeba5056451e438fda3210f4d6ff6"
    sha256 cellar: :any_skip_relocation, ventura:       "38e668d813639143b11cf12e6e52f62bd0b99095904c8949fd01e44df0e4816e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376aa0529f029d4cf665816e99881f0ffbebbbdfa273f544f19c64984dd2f8de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6d4ca208c0991447476e00fe360d52d6820a809587ffba8dbbfb906d52a8b74"
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
