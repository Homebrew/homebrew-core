class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-20.2.0.tgz"
  sha256 "2768b4253d0d83d9fc02e5ecd7f2c60620575800be03954ecd4ec0545aecb25c"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3401677a475411d9fb557aacb5ac3981af9706679e8478bea899ff53c799c35d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/release-it -v")
    (testpath/".release-it.json").write("{\"foo\": \"bar\"}")
    (testpath/"package.json").write("{\"name\":\"test-pkg\",\"version\":\"1.0.0\"}")
    assert_match(/Let's release test-pkg.+\(1\.0\.0\.\.\.1\.0\.1\).+Empty changelog.+Done \(in \d+s\.\)/m,
      shell_output("#{bin}/release-it --npm.skipChecks --no-npm.publish --ci"))
    assert_match "1.0.1", (testpath/"package.json").read
  end
end
