class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.34.0.tgz"
  sha256 "549827fdc059aea4ffce08778f0c55fea50ad7465c065dd2033a1a561542ce9f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52ade089c200b78c70396ed12a25e677c25c53f961e79f6cd23facb7a2b1947e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72d9f53fa71d40ce7c328b30d992ebe532fba45f359c6ebd448ab3951ae59758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63b421e946562c52b375493998be63bc4f6fb72c3c137161855e5363313dbd61"
    sha256 cellar: :any_skip_relocation, sonoma:         "70d0bbb627e1c63b459ae0afeea350eddf2e7fdcf71f58b95184ef8c1e158ac2"
    sha256 cellar: :any_skip_relocation, ventura:        "83c3d0034c52260c9e1488ca56c71e2cc74e7df6ee7160b9f4d306c4025fc083"
    sha256 cellar: :any_skip_relocation, monterey:       "1bb197bfb5bf3a42f888245fc5a2ac76b39bf93b74bb07d71ec62617585a653f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3460794444bc98ee3c07ee32f27ad2c2866248c08d0d5183a7d045c8942eede3"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
