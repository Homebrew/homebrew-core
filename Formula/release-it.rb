require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.3.0.tgz"
  sha256 "33448b3782659e39d4096cf73ab20b4a360b38d14844360133c5a0c546a52c8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cab9752ea26dcb32890b0ef79922c360dec471534fab89f23b05a3894b3cde63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cab9752ea26dcb32890b0ef79922c360dec471534fab89f23b05a3894b3cde63"
    sha256 cellar: :any_skip_relocation, monterey:       "3c81a8573630e4de45ff311e06fb8a0ee86931848f8a01e04b6e7e370e0f5673"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c81a8573630e4de45ff311e06fb8a0ee86931848f8a01e04b6e7e370e0f5673"
    sha256 cellar: :any_skip_relocation, catalina:       "3c81a8573630e4de45ff311e06fb8a0ee86931848f8a01e04b6e7e370e0f5673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cab9752ea26dcb32890b0ef79922c360dec471534fab89f23b05a3894b3cde63"
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
