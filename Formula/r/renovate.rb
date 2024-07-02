require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.422.0.tgz"
  sha256 "d328e129460fd3daf684adc20b9aab799887b4b69766a5e6a3b736e8de05a06d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76bc348371c49250bfa0d9b3d817e4a03ecc733ef64085e04784523220bfeef9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f61ec9a239ad46c3b16dc77b3ff73d9c6e55e27b8eef0810867ce617ba1b770"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f20d88d4bb570a51dda4821c09075dcd2321b79e8a349a1d467daa4830d328"
    sha256 cellar: :any_skip_relocation, sonoma:         "af786c16e49337d179c98eabe20d050154efd5364dcf56c2a19161f6ed3db378"
    sha256 cellar: :any_skip_relocation, ventura:        "6e2b241d7012b198fb80a375e82f215147552505756a100e65427a93b437679d"
    sha256 cellar: :any_skip_relocation, monterey:       "b9dcf1cbb5cda6d0c3219c34308cb5bc8bce01a27036f4fbe892abc30cf7d5fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5a9aa0c66afd368a9d80713db9aac01243b2d914e99e95a8b890db8ff0bf335"
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
