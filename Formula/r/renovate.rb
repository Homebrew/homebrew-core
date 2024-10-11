class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.117.0.tgz"
  sha256 "a0b99d0eaea99c1a866c67bfe5af4691aaf4ef1faea8998612a1779e26d65508"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36f57e2b3a7ae0ab6c25ff50923ffc5bd8bec4c16544e3ecfe2ccd1ba47a3469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb93ba035aa4a2faa7f65a854b91f4bfcb53466eee20d76507c01dc0c46b46a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77a5a2436315779755b474ff7e351bbb3654c9f030acdba6b5440b36ed39329d"
    sha256 cellar: :any_skip_relocation, sonoma:        "39cc1b7ba787a5ef424283035c2c7003950ff01d89249c455b9ec705c9471f7d"
    sha256 cellar: :any_skip_relocation, ventura:       "7a4c3f3fca68dc9fd9fdcc60d195b0b91d95fda2f86a0065d34fa37cc06131cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c397729f94405d1369d83f388add582df5c287355716a47f59ffbd425b50cc18"
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
