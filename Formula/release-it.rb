require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.0.0.tgz"
  sha256 "52a22039887a5a131db2a3b8c524bd57f9bda4a091567711f5c5ee9cee8f8751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e05630e5ab2ad2d2397a793d2b5a1b3bd1a142f56752e206a2bc757ecf1ad6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e05630e5ab2ad2d2397a793d2b5a1b3bd1a142f56752e206a2bc757ecf1ad6b"
    sha256 cellar: :any_skip_relocation, monterey:       "b2c693ac53ca3f66b721e78da2e60173a9467c3b3c81cb00e3eb9c1522ff2249"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2c693ac53ca3f66b721e78da2e60173a9467c3b3c81cb00e3eb9c1522ff2249"
    sha256 cellar: :any_skip_relocation, catalina:       "b2c693ac53ca3f66b721e78da2e60173a9467c3b3c81cb00e3eb9c1522ff2249"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e05630e5ab2ad2d2397a793d2b5a1b3bd1a142f56752e206a2bc757ecf1ad6b"
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
