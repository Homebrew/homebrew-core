class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-19.0.2.tgz"
  sha256 "01479d1ce2790bb3cd627b30aa76a4330aa6e9e33d0c866520fc6e9d3dd68690"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e2b43473116c1d1503893eeeb35f0d1e24426e514a0a2459b30556b625d309"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46e2b43473116c1d1503893eeeb35f0d1e24426e514a0a2459b30556b625d309"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46e2b43473116c1d1503893eeeb35f0d1e24426e514a0a2459b30556b625d309"
    sha256 cellar: :any_skip_relocation, sonoma:        "afd352d5a5a5ae9fd7925685e4245fbfe1b3ba37e6d9ff6a9497d1b84c9712eb"
    sha256 cellar: :any_skip_relocation, ventura:       "afd352d5a5a5ae9fd7925685e4245fbfe1b3ba37e6d9ff6a9497d1b84c9712eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e2b43473116c1d1503893eeeb35f0d1e24426e514a0a2459b30556b625d309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e2b43473116c1d1503893eeeb35f0d1e24426e514a0a2459b30556b625d309"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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
