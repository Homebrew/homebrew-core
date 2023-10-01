require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.2.0.tgz"
  sha256 "a0864063f413874c0de398ff1560b1cc3ac0ba4bc0dae7525e5d76b52549c655"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baa467dd14c52fac860d5e358033e018192b7ab7e50e32037593729afddcdfe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "baa467dd14c52fac860d5e358033e018192b7ab7e50e32037593729afddcdfe1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa467dd14c52fac860d5e358033e018192b7ab7e50e32037593729afddcdfe1"
    sha256 cellar: :any_skip_relocation, ventura:        "3783192f9ba57404e2866a13da55044ca351a0f5991b90a348995409467ff3e5"
    sha256 cellar: :any_skip_relocation, monterey:       "3783192f9ba57404e2866a13da55044ca351a0f5991b90a348995409467ff3e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3783192f9ba57404e2866a13da55044ca351a0f5991b90a348995409467ff3e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa467dd14c52fac860d5e358033e018192b7ab7e50e32037593729afddcdfe1"
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
