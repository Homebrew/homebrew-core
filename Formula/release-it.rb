require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.9.0.tgz"
  sha256 "10bd6205454e2a3bc02c9881c23e2349cacf99a90ac117c462fd32fb125b10a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75bf9185170cd48d592dca0e83794b91d88391288460889bf4eb7f351c2d12c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75bf9185170cd48d592dca0e83794b91d88391288460889bf4eb7f351c2d12c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75bf9185170cd48d592dca0e83794b91d88391288460889bf4eb7f351c2d12c6"
    sha256 cellar: :any_skip_relocation, ventura:        "d8310f0d76c011750137931c814de42caba6b6c845ef96e568d7d430da8ce812"
    sha256 cellar: :any_skip_relocation, monterey:       "d8310f0d76c011750137931c814de42caba6b6c845ef96e568d7d430da8ce812"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8310f0d76c011750137931c814de42caba6b6c845ef96e568d7d430da8ce812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75bf9185170cd48d592dca0e83794b91d88391288460889bf4eb7f351c2d12c6"
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
