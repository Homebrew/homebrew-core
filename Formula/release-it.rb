require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.5.0.tgz"
  sha256 "6167426a9f25c07743e6723a168bb16ee1f635c8661953439cdc8bc2220c1baa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "403af15d31615e3a4fecc777ac02e52c50d67011d112a76b1946149cb2d18307"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "403af15d31615e3a4fecc777ac02e52c50d67011d112a76b1946149cb2d18307"
    sha256 cellar: :any_skip_relocation, monterey:       "a0c39c774a4485e968c32f18ed381fcfe4213fc1616671c9cb49006d34aff7e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0c39c774a4485e968c32f18ed381fcfe4213fc1616671c9cb49006d34aff7e8"
    sha256 cellar: :any_skip_relocation, catalina:       "a0c39c774a4485e968c32f18ed381fcfe4213fc1616671c9cb49006d34aff7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "403af15d31615e3a4fecc777ac02e52c50d67011d112a76b1946149cb2d18307"
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
