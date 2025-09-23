class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-19.0.4.tgz"
  sha256 "a93098b6d129bcd3e2fa187b66c318a5a198b1c442029da5dd10c0c4fa302458"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9125cfd8a7c84467f6da99ef57e884a28d7052f89d953d1af8eb4b0fead9658d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c49a9c8b7ef3b67f6c86f84ec6a2947e5031989438be7515bf06b1a078967eda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c49a9c8b7ef3b67f6c86f84ec6a2947e5031989438be7515bf06b1a078967eda"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c49a9c8b7ef3b67f6c86f84ec6a2947e5031989438be7515bf06b1a078967eda"
    sha256 cellar: :any_skip_relocation, sonoma:        "c984e38528dffbe119434fd5d19fbc351048b1c68387997c1e1fa6831a0cdcb7"
    sha256 cellar: :any_skip_relocation, ventura:       "c984e38528dffbe119434fd5d19fbc351048b1c68387997c1e1fa6831a0cdcb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3346dd7a6ef8799ed5ddcb162ece0717fe94744c7e2f03d00e79872ad9a12fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a648d5d8235b157ca310272fdd918b7971064119f2095b6fc0c930e6a9c7fe1"
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
