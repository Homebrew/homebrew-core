require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.5.0.tgz"
  sha256 "6167426a9f25c07743e6723a168bb16ee1f635c8661953439cdc8bc2220c1baa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6bd62de1415efb506cef8a07ab8aa624132d3bd96aa38d0b4f267aa2f792fb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6bd62de1415efb506cef8a07ab8aa624132d3bd96aa38d0b4f267aa2f792fb5"
    sha256 cellar: :any_skip_relocation, monterey:       "c34d6d457c3cd7b4abd162bf487859d7670479f965a4baf3d9982815d7d955f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c34d6d457c3cd7b4abd162bf487859d7670479f965a4baf3d9982815d7d955f0"
    sha256 cellar: :any_skip_relocation, catalina:       "c34d6d457c3cd7b4abd162bf487859d7670479f965a4baf3d9982815d7d955f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6bd62de1415efb506cef8a07ab8aa624132d3bd96aa38d0b4f267aa2f792fb5"
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
