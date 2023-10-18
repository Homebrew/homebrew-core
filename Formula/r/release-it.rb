require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-16.2.1.tgz"
  sha256 "b3ed1dcea2f9436de64684f10debb640178b56a8eddfe962060b9cb242d6f4b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "085aadf8b83ec9bab890b34442c8c983b465debd497a213e0f64c8a9a25fd9ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "085aadf8b83ec9bab890b34442c8c983b465debd497a213e0f64c8a9a25fd9ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "085aadf8b83ec9bab890b34442c8c983b465debd497a213e0f64c8a9a25fd9ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "72b2b4e7e7bb835465358427041008b79822e6b8a9fc1e1fe905dd2cc688f007"
    sha256 cellar: :any_skip_relocation, ventura:        "72b2b4e7e7bb835465358427041008b79822e6b8a9fc1e1fe905dd2cc688f007"
    sha256 cellar: :any_skip_relocation, monterey:       "72b2b4e7e7bb835465358427041008b79822e6b8a9fc1e1fe905dd2cc688f007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "085aadf8b83ec9bab890b34442c8c983b465debd497a213e0f64c8a9a25fd9ed"
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
