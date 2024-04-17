require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.2.0.tgz"
  sha256 "2bbbbe21ac13bfb14e7c5d228da79dfef55b5991abd2b6742298a78c08df7c7e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "039f557ecda5d8673f059868a428f614120c1b815ba69f5b7ab1289b38d862d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "039f557ecda5d8673f059868a428f614120c1b815ba69f5b7ab1289b38d862d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "039f557ecda5d8673f059868a428f614120c1b815ba69f5b7ab1289b38d862d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb60b140b433d982d1028515a5cc9de18d8bc23356a722709cce422f9bceb892"
    sha256 cellar: :any_skip_relocation, ventura:        "fb60b140b433d982d1028515a5cc9de18d8bc23356a722709cce422f9bceb892"
    sha256 cellar: :any_skip_relocation, monterey:       "fb60b140b433d982d1028515a5cc9de18d8bc23356a722709cce422f9bceb892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "039f557ecda5d8673f059868a428f614120c1b815ba69f5b7ab1289b38d862d5"
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
