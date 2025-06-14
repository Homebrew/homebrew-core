class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.55.0.tgz"
  sha256 "4040f79fdc2f7c5f1323a0952f7969b2cdbddfe91e9c404774a8f3582de54b51"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d84cbb97d53ed1eb2abe1ea7076698e7f603fd2f109b5eb86e6cdebe6f70d345"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64224c33f9597997f553932ccd7ec19fe64dcc291d13594fe19d695fa55f87c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c54079faacf4c029f76f2d532e2199a269177add71f81a0c9ba057812e1cffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd8421300c23cb94128bd729c1bf7e6f5b7ac2b3f343a8b680312403839113ff"
    sha256 cellar: :any_skip_relocation, ventura:       "ec5929ce1af2b27250fa0483692844931fd91c75d7a2ff1049c5c85c53718a66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a17163dcdf7d6011106d6ac41ccdc3c60eae2c12038b7b8d115a7a7d96b66fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1966fedbfd80ccd3d2eec398d8fde11b62fbc2fe98f466f7a72554e5d9c71024"
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
