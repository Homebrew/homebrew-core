require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-15.9.3.tgz"
  sha256 "22849085db9242bce5aa396366e316110ebf7a120efe56ed062ca77cb9ef10b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f559ccf5127bc56349531821fb3fb5391ac6f8a0af89a295d4632776ef70d216"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f559ccf5127bc56349531821fb3fb5391ac6f8a0af89a295d4632776ef70d216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f559ccf5127bc56349531821fb3fb5391ac6f8a0af89a295d4632776ef70d216"
    sha256 cellar: :any_skip_relocation, ventura:        "cfd8d89de2e94b7ffa1172dc8c16aa06eb6de79053b8228747f1e7460cac4ca0"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd8d89de2e94b7ffa1172dc8c16aa06eb6de79053b8228747f1e7460cac4ca0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfd8d89de2e94b7ffa1172dc8c16aa06eb6de79053b8228747f1e7460cac4ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f559ccf5127bc56349531821fb3fb5391ac6f8a0af89a295d4632776ef70d216"
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
