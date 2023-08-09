require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.40.0.tgz"
  sha256 "56ec0425b8aef58d0d5060983ef4b15df571e1844fec0c80e129171081de908f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecdf8f6b421ec54e900b17a7c1135a51fa44a627aba12b3479d57c205c4a6eda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e6659e1cbe8f447a2d01feefd4cf3b00f8daed73cf0061179c6503ca315d37e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b712960b3daad2b5cb13da7e776ef083f4e434faba611d8ff78e48005a40876"
    sha256 cellar: :any_skip_relocation, ventura:        "1fb4493e6e6a789246c6b48327dd0cbdb70636ea6ade63483953e6d1867a4771"
    sha256 cellar: :any_skip_relocation, monterey:       "06661db6d798f7b7f381b0b6c2f7d2e84169394d859896d4e94e6eb70e00c44e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8401f4bc109709c1fd417e84d2d584dcbdb5df2ced8974c8c12a026a95ab40b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eaffe073cc393d3deef935505ba668c67e1812f744679c381e8dbe69d69bc8a"
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
