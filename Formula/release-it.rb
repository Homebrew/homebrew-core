require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.9.1.tgz"
  sha256 "65135db9ef5a9ce38890a937d375a90e22ef1b08fc9c7107c06aba6cf2f22a6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b78e70655ffd7ee2850467eda253cdfcb705f919c8b851ba27ab645a9f5f6b6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b78e70655ffd7ee2850467eda253cdfcb705f919c8b851ba27ab645a9f5f6b6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b78e70655ffd7ee2850467eda253cdfcb705f919c8b851ba27ab645a9f5f6b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "440ba10a203c2fd5a1af3233cf41c91d8b34e6a60072db3f6ee1991b1bb29a38"
    sha256 cellar: :any_skip_relocation, monterey:       "440ba10a203c2fd5a1af3233cf41c91d8b34e6a60072db3f6ee1991b1bb29a38"
    sha256 cellar: :any_skip_relocation, big_sur:        "440ba10a203c2fd5a1af3233cf41c91d8b34e6a60072db3f6ee1991b1bb29a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b78e70655ffd7ee2850467eda253cdfcb705f919c8b851ba27ab645a9f5f6b6a"
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
