require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.1.4.tgz"
  sha256 "560608fea32fb199c8734d92beac2ea5a005933648c67da3e4ac8ffa4f57fa98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "353d3c9dfdb9db8d69d30a071b8b1eb86cbd5ee806226120016c5ac99b6ac2f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "353d3c9dfdb9db8d69d30a071b8b1eb86cbd5ee806226120016c5ac99b6ac2f6"
    sha256 cellar: :any_skip_relocation, monterey:       "8e2f737a617703c54da8b8a491a854d31cd0e313f8bb6c422a720d98abe36692"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e2f737a617703c54da8b8a491a854d31cd0e313f8bb6c422a720d98abe36692"
    sha256 cellar: :any_skip_relocation, catalina:       "8e2f737a617703c54da8b8a491a854d31cd0e313f8bb6c422a720d98abe36692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "353d3c9dfdb9db8d69d30a071b8b1eb86cbd5ee806226120016c5ac99b6ac2f6"
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
