require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.401.0.tgz"
  sha256 "5e49327aed4f1cac03afcbe1eb16eb33b2b16ff957ee8573e4489dc14d2f75e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "735f0341bfb6e1a48cbfcf0e83bd69dd00c71106746f4e948cc9d9660d43be39"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44493b658eb18b52bb0828f31c63b03818b17ec354fa084fe855c3257fdcaeb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae76ef4813ea5ddaaf72b638d6bd569168e5b393e526f517d85f8d1f78c902c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ac8905358a510d4f6822dfbd348f9a2bd2004e9ee2ed49a398bfd887962ad2b"
    sha256 cellar: :any_skip_relocation, ventura:        "fe3b3fdc88d28a9111ff8837434af61e9dde2be0da6a4d40b634ea43c7070364"
    sha256 cellar: :any_skip_relocation, monterey:       "380f7f7d1f9902754c56d7cfbd50436a4a20d2d35bc1cc705e8fe739d044eced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70d48ed099a66af10f60443eb1a40379c8ef2e0776273ac60be3c7605711a1e2"
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
