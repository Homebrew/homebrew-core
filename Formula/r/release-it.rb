require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.2.1.tgz"
  sha256 "8718cee7ad3a0b88ce53793b0ea6c36c68a99663c6126ed5d6da626d82dc9c3f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7bae38060386166eb4e8d2b356ef38b97c39366b0de891476aa46bfa0b11351"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7bae38060386166eb4e8d2b356ef38b97c39366b0de891476aa46bfa0b11351"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7bae38060386166eb4e8d2b356ef38b97c39366b0de891476aa46bfa0b11351"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8390ad22cdd5b196d5cf2bb3d2ab2d281e277a8f1b15ebab65406f314bb50a0"
    sha256 cellar: :any_skip_relocation, ventura:        "f8390ad22cdd5b196d5cf2bb3d2ab2d281e277a8f1b15ebab65406f314bb50a0"
    sha256 cellar: :any_skip_relocation, monterey:       "f8390ad22cdd5b196d5cf2bb3d2ab2d281e277a8f1b15ebab65406f314bb50a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7bae38060386166eb4e8d2b356ef38b97c39366b0de891476aa46bfa0b11351"
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
