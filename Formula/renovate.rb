require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.117.0.tgz"
  sha256 "632ad307bc70a1838290cda5b85384cc2eff529c386675f5c1de93c8adee2728"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff4509643f724eca6d1f3c90f95322a48dac2697a8a967a6868b43ee70deabea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6231252ff2edac5665f145ae2e507d05d616d4ec05c0df631c5d7d78bc019e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6af4d771e3819535012f58f655f9b9ed9ac4d60c982f9f0dd8f4ac92c6a0b58"
    sha256 cellar: :any_skip_relocation, ventura:        "94afe2061d84ad8b7fe815b767dc8590aab1ade3326324e91003d2c33c19d45d"
    sha256 cellar: :any_skip_relocation, monterey:       "e3dd4f97f5b167baaec841d6c44fe99e0cf11c44fcb24b4f5b9245ca0a7fc2aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4f3e050203e41fddf84cab5f912e018e88e50ee6579fb580119409cbfba5608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52463a50859d0bb6fc0cde6a1968bedbc647c0af790c32745bab106aec270e6d"
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
