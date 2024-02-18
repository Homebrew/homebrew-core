require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.0.5.tgz"
  sha256 "6a689262cf62a8bac616e53e06a66ffc6554d46eb1287e80693702cdedbf8cd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44b2384f15c98f8996bdb0a483ba1feb3b15981121324578189a5c30b646771a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44b2384f15c98f8996bdb0a483ba1feb3b15981121324578189a5c30b646771a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44b2384f15c98f8996bdb0a483ba1feb3b15981121324578189a5c30b646771a"
    sha256 cellar: :any_skip_relocation, sonoma:         "18cfb274b9778f6a5fdc8645518df9b14a290066cb4cc60a3682f634ca6dd751"
    sha256 cellar: :any_skip_relocation, ventura:        "18cfb274b9778f6a5fdc8645518df9b14a290066cb4cc60a3682f634ca6dd751"
    sha256 cellar: :any_skip_relocation, monterey:       "18cfb274b9778f6a5fdc8645518df9b14a290066cb4cc60a3682f634ca6dd751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44b2384f15c98f8996bdb0a483ba1feb3b15981121324578189a5c30b646771a"
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
