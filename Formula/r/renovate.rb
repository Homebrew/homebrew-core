class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.120.0.tgz"
  sha256 "1bb257b636857d341479f366a75fee90088e5aa3849042a7740151487055da7e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfb84cc62c353afa3bdefb6d8f4aab2154702f5e0cd1d847b5ef1d448df180b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "092b42d4bbf63dc6c2cd4114bda7032eab75e11c0e49486c96d4f881b99ff8c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "922ad8466c875fd2d4ff5b73a17cf5e4babff9b18c5a70fe571c832ebb66e4d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "584b43ede04fc0cf52d34e7955e80c8a14ae2b4f49669ee17ec6f542be6bbee6"
    sha256 cellar: :any_skip_relocation, ventura:       "287179a78488786e0b2c5d445a3225d9bf5f17a8f4e4fda2b5cb34d9ac09fb92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ad9e6b181c2f0db34664a95e5e98d3d14b9a52227ef1b2113906379c4dc98a"
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
