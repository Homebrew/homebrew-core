class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.10.0.tgz"
  sha256 "1073f1e057022afb219501b51a6eb5fd36ea5c3ae2c7215b7e272dea19046e3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "844e3ceef74aa6fa0582383160450efacd48f0b29121a9f21a4993de10e13ce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "844e3ceef74aa6fa0582383160450efacd48f0b29121a9f21a4993de10e13ce1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "844e3ceef74aa6fa0582383160450efacd48f0b29121a9f21a4993de10e13ce1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eff7aba1319495e91debd6f00c07da3078d1853590d4b95afb98c24dbe379f7b"
    sha256 cellar: :any_skip_relocation, ventura:       "eff7aba1319495e91debd6f00c07da3078d1853590d4b95afb98c24dbe379f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "844e3ceef74aa6fa0582383160450efacd48f0b29121a9f21a4993de10e13ce1"
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
