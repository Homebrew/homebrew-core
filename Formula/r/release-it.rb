class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-18.1.2.tgz"
  sha256 "f35150b5144779a0cea9fc1929ef611e83d7a2f30ae0c622a9015ad3891ca167"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d134f703a9f2370491711555ec5a6e5fd56191cbf146dafac8fc4b6cce589794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d134f703a9f2370491711555ec5a6e5fd56191cbf146dafac8fc4b6cce589794"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d134f703a9f2370491711555ec5a6e5fd56191cbf146dafac8fc4b6cce589794"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9e29f79b5bb405179134e0c540301da0ff5f2870990ff89b53e7579e3cfaebb"
    sha256 cellar: :any_skip_relocation, ventura:       "a9e29f79b5bb405179134e0c540301da0ff5f2870990ff89b53e7579e3cfaebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e25057ab9adb9f425648790faacc5aaa68c1679ef43571da31ca41ac9b1cf1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d134f703a9f2370491711555ec5a6e5fd56191cbf146dafac8fc4b6cce589794"
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
