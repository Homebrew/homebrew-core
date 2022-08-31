require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.4.1.tgz"
  sha256 "5142bf2981cb56f0d13ffd7c1c584b106bac732b5cf115786828e641d0f2ab62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1e90bae8ff51c3edffbfc5a454c20a5d739a9b8ad56b5345485ee4475aa83bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1e90bae8ff51c3edffbfc5a454c20a5d739a9b8ad56b5345485ee4475aa83bd"
    sha256 cellar: :any_skip_relocation, monterey:       "01cfb297995cecdcd24e24dd1ad6742133a54141eb6b1721f47def0bbb55ff1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "01cfb297995cecdcd24e24dd1ad6742133a54141eb6b1721f47def0bbb55ff1f"
    sha256 cellar: :any_skip_relocation, catalina:       "01cfb297995cecdcd24e24dd1ad6742133a54141eb6b1721f47def0bbb55ff1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1e90bae8ff51c3edffbfc5a454c20a5d739a9b8ad56b5345485ee4475aa83bd"
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
