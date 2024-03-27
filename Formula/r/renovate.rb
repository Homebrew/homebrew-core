require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.272.0.tgz"
  sha256 "805ede88653f00ff7f167f5b3d630ab276af7023ca5e5b2f1a6f8d7f03fe8776"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab57dad7766d0ab22cdaf09239faffd663b41eb7b79c8351db455ccaa7cebb73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4459931d3e72d45de7d59f459cd4394abcb9e2206ac18d9fc4d1225caaeded83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad3dfdeaaed095dd3db251500f181906334c44a4b15ad9144eff079be05d8f7c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a04cd6bd4dbed094105e5710bc60f59450e3718a9e299a034b014b7910bc0c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "3e8613388e5c30086432ebb9dcc755b3afdff48a5e2f809d4730ed1f0eb191fc"
    sha256 cellar: :any_skip_relocation, monterey:       "733c847895a03d7a4455de0b017bdab21cd73ac2f3b6f05c60a2e3da65b4423d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "042184dcef14468d7d73a43423ec61a0a6920ea42b11aef1e9f52f332b967e54"
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
