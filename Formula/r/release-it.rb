require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.1.5.tgz"
  sha256 "e67b7b554d35f7a8e42000005d39108d064dade3764257bd38f3a5fd19ecedb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3fb263caa5f5b87a21fe271249b498ea9c64d6f4983c00637db3324c6a73e97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3fb263caa5f5b87a21fe271249b498ea9c64d6f4983c00637db3324c6a73e97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3fb263caa5f5b87a21fe271249b498ea9c64d6f4983c00637db3324c6a73e97"
    sha256 cellar: :any_skip_relocation, ventura:        "4e48fa486f736b637dbb648f6dc088d1ef8531ff8673e0322e3d6090780b5795"
    sha256 cellar: :any_skip_relocation, monterey:       "4e48fa486f736b637dbb648f6dc088d1ef8531ff8673e0322e3d6090780b5795"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e48fa486f736b637dbb648f6dc088d1ef8531ff8673e0322e3d6090780b5795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3fb263caa5f5b87a21fe271249b498ea9c64d6f4983c00637db3324c6a73e97"
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
