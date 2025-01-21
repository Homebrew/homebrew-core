class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-18.1.1.tgz"
  sha256 "927d0d0e6b69a06aa929f8e01179ea828b782faffdc56bce673bd414429c497e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e23e9fe6d5f5edc6e0cca88b9467f0d978c73f08bbcee518ab61f16715271929"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e23e9fe6d5f5edc6e0cca88b9467f0d978c73f08bbcee518ab61f16715271929"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e23e9fe6d5f5edc6e0cca88b9467f0d978c73f08bbcee518ab61f16715271929"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c5ac9fd715cd65916a4de8a96063c89b32067198d767d78a873ef8890bb583d"
    sha256 cellar: :any_skip_relocation, ventura:       "3c5ac9fd715cd65916a4de8a96063c89b32067198d767d78a873ef8890bb583d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e23e9fe6d5f5edc6e0cca88b9467f0d978c73f08bbcee518ab61f16715271929"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
