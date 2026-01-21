class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-19.2.4.tgz"
  sha256 "56c91ae9295a790fab1b96beeb823855cb6eb3e52c70bce1ec0befd22db2ea7a"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28bedf74932fc5949dd5a17c7bb06359d4572ad7b117a0dbf37425b51f162825"
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
