class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.20.0.tgz"
  sha256 "eb5ab215a887a3587a939b1a9cefadc86a3f86ae2f122f11e91533ca9ec77137"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb805bcc79beec6152e66a666d27b0b195657ffe31aecd202d45cafe4f1b688a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e40e07109d4d6e96d78bb2bb6e313bb360d9da581030a526d2ed9e937847beb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d41a3c0b4cf38a2e2ccc183dff3c068e662accadaa9382de84c1e16ab0fd4fba"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab22418e0f4b0cec27c07a3aa98280deae3bd566ad145cc40309e1a7adf5bf12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56260cd22c6f373c0a7bdb126c606eb441871b1c1d9e14baa27dbdbace4ac5e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87a027e5ba39e53a2098d53a2ac70ebf9a0645041a2681668cb41a4b74785105"
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
