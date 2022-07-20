require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.1.3.tgz"
  sha256 "c1a418dd58343e8cdae53e124757fc617ad163093879f26c20d7ef6cf1fee942"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5829fb235e79906c5ddc034216e21100995810df516910a0a947d9971eb1410f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5829fb235e79906c5ddc034216e21100995810df516910a0a947d9971eb1410f"
    sha256 cellar: :any_skip_relocation, monterey:       "c11ab3963e56dbaa265bfe6f5ed2ebf0980bd73dc065d02987572d39c0632202"
    sha256 cellar: :any_skip_relocation, big_sur:        "c11ab3963e56dbaa265bfe6f5ed2ebf0980bd73dc065d02987572d39c0632202"
    sha256 cellar: :any_skip_relocation, catalina:       "c11ab3963e56dbaa265bfe6f5ed2ebf0980bd73dc065d02987572d39c0632202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5829fb235e79906c5ddc034216e21100995810df516910a0a947d9971eb1410f"
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
