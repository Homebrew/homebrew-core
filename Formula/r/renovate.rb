require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.247.0.tgz"
  sha256 "9784873093cace07cac0e551fa0531a66f1d5a05d4775cdfab64d519e840d2be"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e77a5bb7e1e90398dd4aa08d335afea9a8e4ed0a6dc5f44562be2489cc382ecc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2aed502d066adb1cbb5d103e558b60930f57b23dd9fb3395d8c2d258cd4b7e4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "785ca56f2322839747451303a394dc91a97215547b23bfa0282a0c22d6ecf34a"
    sha256 cellar: :any_skip_relocation, sonoma:         "95bb35f5668c9bf1072ab0704e09ac6ee882bdaa19f0b4c582559540b227e893"
    sha256 cellar: :any_skip_relocation, ventura:        "764e0ad7c90f840ba7c838a487af15ab979eb3cad814b1899b11b9db68abaaca"
    sha256 cellar: :any_skip_relocation, monterey:       "20ae6c6aebd9240046581e849187c47b747668133ddec26d33e335855530ca8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5c81c0ec358406d252ab1a5a89e2a9a0baff103330a7f93aafd3a21c4857157"
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
