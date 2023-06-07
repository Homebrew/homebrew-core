require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.11.0.tgz"
  sha256 "94cdce80b17ec69604d226292124fb06e2592ed861265c971fb642732ac14204"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9066a76d35575116fdf3c16faec7037f38f173b7f02ae71b6daa4c013b895af0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9066a76d35575116fdf3c16faec7037f38f173b7f02ae71b6daa4c013b895af0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9066a76d35575116fdf3c16faec7037f38f173b7f02ae71b6daa4c013b895af0"
    sha256 cellar: :any_skip_relocation, ventura:        "c63fd9777243210c45745f4dfd4efc11cea56fdb4e24083fd012c6508366c941"
    sha256 cellar: :any_skip_relocation, monterey:       "c63fd9777243210c45745f4dfd4efc11cea56fdb4e24083fd012c6508366c941"
    sha256 cellar: :any_skip_relocation, big_sur:        "c63fd9777243210c45745f4dfd4efc11cea56fdb4e24083fd012c6508366c941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9066a76d35575116fdf3c16faec7037f38f173b7f02ae71b6daa4c013b895af0"
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
