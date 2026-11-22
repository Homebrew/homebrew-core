class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-21.1.3.tgz"
  sha256 "054e70acd9db3f5b20f9874da53ee2b8ef323f163edb898c23a904bdfb56de21"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "c5f600360ea3ebf46c01f78757ebf2241279b8b788d664d0e2f8a8b7eff3646d"
    sha256 cellar: :any_skip_relocation, all: "e3a10e0f51dafe01fb14071b457a726fae98456a0ed1864b4789b713259820e8"
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
