class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.8.2.tgz"
  sha256 "a497d066b3e19016fa20bdddbd095140c1a5ff166a75c3f98cfcf76d2cccb7db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0437aad9b0c8f39be80313ded468c01a6045427c16c86e300a3419ff6e82d334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0437aad9b0c8f39be80313ded468c01a6045427c16c86e300a3419ff6e82d334"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0437aad9b0c8f39be80313ded468c01a6045427c16c86e300a3419ff6e82d334"
    sha256 cellar: :any_skip_relocation, sonoma:        "04bb20db2bc08245a2e7adb3d3bae5e41ad246f876e99cec02f32ed1f9d8cbf0"
    sha256 cellar: :any_skip_relocation, ventura:       "04bb20db2bc08245a2e7adb3d3bae5e41ad246f876e99cec02f32ed1f9d8cbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0437aad9b0c8f39be80313ded468c01a6045427c16c86e300a3419ff6e82d334"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
