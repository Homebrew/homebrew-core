require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.2.0.tgz"
  sha256 "f63b77054968285d6000f66cf4703bfd95ba341c8f48ba4683831c0324d86be0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "627e77cb75b653cba2e3b401c29a0d7992f6bf076798b83aca1512204b030854"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "627e77cb75b653cba2e3b401c29a0d7992f6bf076798b83aca1512204b030854"
    sha256 cellar: :any_skip_relocation, monterey:       "c438e519ac77da1147a1642ca17b76c3c152222a0323a3231ba8cfea23cabf16"
    sha256 cellar: :any_skip_relocation, big_sur:        "c438e519ac77da1147a1642ca17b76c3c152222a0323a3231ba8cfea23cabf16"
    sha256 cellar: :any_skip_relocation, catalina:       "c438e519ac77da1147a1642ca17b76c3c152222a0323a3231ba8cfea23cabf16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "627e77cb75b653cba2e3b401c29a0d7992f6bf076798b83aca1512204b030854"
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
