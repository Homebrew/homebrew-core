require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.9.3.tgz"
  sha256 "22849085db9242bce5aa396366e316110ebf7a120efe56ed062ca77cb9ef10b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbadecebd4e7eba9d8a19133367117a5339bbd16dc5307c526ccb33e08c981a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbadecebd4e7eba9d8a19133367117a5339bbd16dc5307c526ccb33e08c981a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbadecebd4e7eba9d8a19133367117a5339bbd16dc5307c526ccb33e08c981a4"
    sha256 cellar: :any_skip_relocation, ventura:        "7d066b1b83ddfbd8c3b0d09ed03b1e73523151c7ec356a0e3900e2b0d28300a8"
    sha256 cellar: :any_skip_relocation, monterey:       "7d066b1b83ddfbd8c3b0d09ed03b1e73523151c7ec356a0e3900e2b0d28300a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d066b1b83ddfbd8c3b0d09ed03b1e73523151c7ec356a0e3900e2b0d28300a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbadecebd4e7eba9d8a19133367117a5339bbd16dc5307c526ccb33e08c981a4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/release-it -v")
    (testpath/"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(/Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)/m,
      shell_output("#{bin}/release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath/"package.json").read
  end
end
