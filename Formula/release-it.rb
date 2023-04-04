require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.10.1.tgz"
  sha256 "32e7a5ea5ca8203aa39bce1bdf8ae75a62c79abb3d22cb5e500ecf207a91bf0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d683742dd10fb58cbcf2e0153c1a312e1cec99e867c6227c462eaefb05ab7a4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d683742dd10fb58cbcf2e0153c1a312e1cec99e867c6227c462eaefb05ab7a4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d683742dd10fb58cbcf2e0153c1a312e1cec99e867c6227c462eaefb05ab7a4c"
    sha256 cellar: :any_skip_relocation, ventura:        "523d2ccb32f2039db5bfafda0333ad248f686b907efbae7661ba2d9ac3745a61"
    sha256 cellar: :any_skip_relocation, monterey:       "523d2ccb32f2039db5bfafda0333ad248f686b907efbae7661ba2d9ac3745a61"
    sha256 cellar: :any_skip_relocation, big_sur:        "523d2ccb32f2039db5bfafda0333ad248f686b907efbae7661ba2d9ac3745a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d683742dd10fb58cbcf2e0153c1a312e1cec99e867c6227c462eaefb05ab7a4c"
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
