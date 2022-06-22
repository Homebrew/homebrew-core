require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.1.0.tgz"
  sha256 "2fa9f56e92aca3508440daff8a0fbdab14287052b1794340138b095370d1603e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ea194af157af517d6d6090a8a83ff54510b9ce82496027b533ce1c3a61a94ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ea194af157af517d6d6090a8a83ff54510b9ce82496027b533ce1c3a61a94ea"
    sha256 cellar: :any_skip_relocation, monterey:       "058fbdf59ff2c999e466630ec92a28032ac6bf12d233114ab8dc7ee87a7893d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "058fbdf59ff2c999e466630ec92a28032ac6bf12d233114ab8dc7ee87a7893d8"
    sha256 cellar: :any_skip_relocation, catalina:       "058fbdf59ff2c999e466630ec92a28032ac6bf12d233114ab8dc7ee87a7893d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea194af157af517d6d6090a8a83ff54510b9ce82496027b533ce1c3a61a94ea"
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
