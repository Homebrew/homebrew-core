require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.6.0.tgz"
  sha256 "a3e587718ec915689c6bf36c8d309e55fb4aafd16c3af2a210b5d9fb3b4d037c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b00e9d8c68f9bb5e46aa818411d6c5dd38d088836ed8d4216c62cb8fa12c07f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b00e9d8c68f9bb5e46aa818411d6c5dd38d088836ed8d4216c62cb8fa12c07f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b00e9d8c68f9bb5e46aa818411d6c5dd38d088836ed8d4216c62cb8fa12c07f0"
    sha256 cellar: :any_skip_relocation, ventura:        "fcef0872c31ca77a5457c1388c658bf173237494e449374d9e43a6ef541f7442"
    sha256 cellar: :any_skip_relocation, monterey:       "fcef0872c31ca77a5457c1388c658bf173237494e449374d9e43a6ef541f7442"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcef0872c31ca77a5457c1388c658bf173237494e449374d9e43a6ef541f7442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00e9d8c68f9bb5e46aa818411d6c5dd38d088836ed8d4216c62cb8fa12c07f0"
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
