require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.2.0.tgz"
  sha256 "f63b77054968285d6000f66cf4703bfd95ba341c8f48ba4683831c0324d86be0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd75bf0f2f275c5bffec3358a36465c6d4b6c6da93a31a6e0add914d32f98a6f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd75bf0f2f275c5bffec3358a36465c6d4b6c6da93a31a6e0add914d32f98a6f"
    sha256 cellar: :any_skip_relocation, monterey:       "75e9ad440156db03f9d689bf03fb8f483e00ccd0a1725e7be33fd4cdee10d184"
    sha256 cellar: :any_skip_relocation, big_sur:        "75e9ad440156db03f9d689bf03fb8f483e00ccd0a1725e7be33fd4cdee10d184"
    sha256 cellar: :any_skip_relocation, catalina:       "75e9ad440156db03f9d689bf03fb8f483e00ccd0a1725e7be33fd4cdee10d184"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd75bf0f2f275c5bffec3358a36465c6d4b6c6da93a31a6e0add914d32f98a6f"
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
