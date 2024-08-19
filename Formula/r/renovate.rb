class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-38.41.0.tgz"
  sha256 "ed373a0ecad25c53598b174f038932adab80b0c9eca360a21506cabab19b4695"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bf24a59add800d18c4c0d8784f79581aaf6954853cbd2991349340501c5de23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f4c4460747813cafb97f55c91d8e69b6c229f29fbdf22fa93c77b4729f71b7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ded894d8e64f314ba9b253b247becb181b0339e808851211094299552e9a6be7"
    sha256 cellar: :any_skip_relocation, sonoma:         "d42d887978e7707c816951ef9ef0f585258245f06d9ec917477d0d1bb0c43662"
    sha256 cellar: :any_skip_relocation, ventura:        "1e22e2e04f2e056a4250d866ed59730ef50cff8e05947fba980c086e2f17c3ea"
    sha256 cellar: :any_skip_relocation, monterey:       "39e098229a20c068ed13d5b23616f312afdd759599b91590331cd8716bcdc6c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "191e72ef1a9b987ad2ed0295f6e8378a725a58c7506f6e5cd6be20eda95bd9d5"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
