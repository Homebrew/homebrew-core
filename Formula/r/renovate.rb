class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-39.14.0.tgz"
  sha256 "f0892e326a92e214805bc2365383765a71991460a3781090326f9591eb60dfd7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2343bd221211ac0d617c7daa9b806d4cb2b9e4737a58a38333371b9eaa5b149e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13c4b4644866458eb6793303b538a71f0aca66e491e35bbd8a07761524202ff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f930ba94073eb949b6908154fe667a1d8abd1991ecf20b9a49343e18ceb9359"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b52319e358450a7921b0013756f6b10d65242fa9a4868bf67de481f63d6fea6"
    sha256 cellar: :any_skip_relocation, ventura:       "195497a608d78b2ed3dcf2fc7a7d8ff39ad93145fc74a299bfeeec5df98671d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0922177c42529e1400f3d2060bba0af70ac97fcfb2613e6f0df51e2a2543a81"
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
