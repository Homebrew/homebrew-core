class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-40.54.0.tgz"
  sha256 "79d349aef3bb253dd49529faa4649de3fc17695ea4268b093a01e44ac942d1ac"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "756a809f1332716f16fd6664a9c3b1e20cd9c72bbce6162318947aa57645f0e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9c3b4f37ef4861bd7ab9ff66dfe7866d7f57ff5653cfbfa9d12e001454baa76"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1925d0519595f3803cd53419c4140139aa1b859bf25b3800c93ab995550513f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ad45dff4e6dceca1c37adddd95bc41249e79f9071e731c8214d2580a8756cd"
    sha256 cellar: :any_skip_relocation, ventura:       "e2ff1da9e75f7fc401a04193af22669229e857c9af2d43c22d0714287d1c4abb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e36fbd1dd55e56a302db9bf372dc4a3426a00ebd04a2dca68ae13f613f93da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e36ab2bb9b449cb5d7c7769145f1086ed696b9001138abf12d94e64fdbf67e1"
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
