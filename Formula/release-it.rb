require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.1.1.tgz"
  sha256 "5c9db6a40bc7b229bb76d2891b82c120cdb4b4d209a5b4becc9d93657106ca2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ad895947779ba9a8fa398d2ceb4a8000d17022eca0adfbb0c04488462108d3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ad895947779ba9a8fa398d2ceb4a8000d17022eca0adfbb0c04488462108d3c"
    sha256 cellar: :any_skip_relocation, monterey:       "2d3929e8dd1ba8f998ab0ba1719820fa04b0bda55a9ec09b9fc4c44ff1fa7bff"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d3929e8dd1ba8f998ab0ba1719820fa04b0bda55a9ec09b9fc4c44ff1fa7bff"
    sha256 cellar: :any_skip_relocation, catalina:       "2d3929e8dd1ba8f998ab0ba1719820fa04b0bda55a9ec09b9fc4c44ff1fa7bff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad895947779ba9a8fa398d2ceb4a8000d17022eca0adfbb0c04488462108d3c"
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
