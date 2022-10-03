require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.4.3.tgz"
  sha256 "44bb1d294bb560d6a8e2a9d4a962b8b8f96c674fc2d6402d71a74a5158599c9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47cf8a76fee7df9adc0b8d3d1479a76c53d34cc3069e1492c0172b124b75a178"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47cf8a76fee7df9adc0b8d3d1479a76c53d34cc3069e1492c0172b124b75a178"
    sha256 cellar: :any_skip_relocation, monterey:       "04dcd7de9dfccd01d57fd8717495b6c5de4137396d6a6268fd029806c3b1c102"
    sha256 cellar: :any_skip_relocation, big_sur:        "04dcd7de9dfccd01d57fd8717495b6c5de4137396d6a6268fd029806c3b1c102"
    sha256 cellar: :any_skip_relocation, catalina:       "04dcd7de9dfccd01d57fd8717495b6c5de4137396d6a6268fd029806c3b1c102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47cf8a76fee7df9adc0b8d3d1479a76c53d34cc3069e1492c0172b124b75a178"
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
