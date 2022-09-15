require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.4.2.tgz"
  sha256 "a50ab9957c02bef505cff564db15e2a3ab0ffe95016fc934d9a3b92d4e2ae690"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fd1e09ca187017b9d77b8b89b353b0dd9d36bf651dc31e6f1a93c47b50c3b13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fd1e09ca187017b9d77b8b89b353b0dd9d36bf651dc31e6f1a93c47b50c3b13"
    sha256 cellar: :any_skip_relocation, monterey:       "757a362118a9b1af65ba6a9d9adb2cea09740ad7b63fe738893fb83cf8977eb9"
    sha256 cellar: :any_skip_relocation, big_sur:        "757a362118a9b1af65ba6a9d9adb2cea09740ad7b63fe738893fb83cf8977eb9"
    sha256 cellar: :any_skip_relocation, catalina:       "757a362118a9b1af65ba6a9d9adb2cea09740ad7b63fe738893fb83cf8977eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fd1e09ca187017b9d77b8b89b353b0dd9d36bf651dc31e6f1a93c47b50c3b13"
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
