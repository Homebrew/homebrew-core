class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.122.0.tgz"
  sha256 "083f8e3f8436dc3a983aa85d283cd9b708d1892ce1bae5015c53313359995d7c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963ecd6393acbfa89234b12beb21855e46af3c0a554284ad7c6f740d957ad766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3e89565adef3b22d6bca8cf5f6692ab946f166b01002908090e104b54ba4ad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9875c93bc001346fa3f6fc2867c403d565f512edd8251cd9209491abc057824b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b7d76dc00bd19a2ef513019555123df10dd78574e404e9771228f3c2e77883b"
    sha256 cellar: :any_skip_relocation, ventura:       "940a05b64066d31ec4c6d777b5a4e9a848bb7206ae6c5bb9491985840b5f5832"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66346db7d6c675aee4ef29e685ea01fab160aaa472fa156759f4d50240833045"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
