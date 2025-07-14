class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-19.0.3.tgz"
  sha256 "f7e8ed7e8b3918cb4311c7b7702acaace6f93a7b602c0535642d7f1abc9dedfd"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "657dca8091343594aa109d9fd3eb2d2b476d7b4ccb9adaa9032b4e80180d285a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "657dca8091343594aa109d9fd3eb2d2b476d7b4ccb9adaa9032b4e80180d285a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "657dca8091343594aa109d9fd3eb2d2b476d7b4ccb9adaa9032b4e80180d285a"
    sha256 cellar: :any_skip_relocation, sonoma:        "250475385c0db58c64e62b832b4e9cd8b7d52ac3a95e293867a9be5674a4f874"
    sha256 cellar: :any_skip_relocation, ventura:       "250475385c0db58c64e62b832b4e9cd8b7d52ac3a95e293867a9be5674a4f874"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "657dca8091343594aa109d9fd3eb2d2b476d7b4ccb9adaa9032b4e80180d285a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "657dca8091343594aa109d9fd3eb2d2b476d7b4ccb9adaa9032b4e80180d285a"
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
