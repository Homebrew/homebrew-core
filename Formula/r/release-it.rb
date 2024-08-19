class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.6.0.tgz"
  sha256 "bcdd80d759a96b8dbca3d662b5b33c3615fc82284412b6f23554e248250d1be5"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc2f4cb596c2505b3d46890c594e7d89f4ea22b2b01fd4a4cab39dc73e2e8c67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc2f4cb596c2505b3d46890c594e7d89f4ea22b2b01fd4a4cab39dc73e2e8c67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc2f4cb596c2505b3d46890c594e7d89f4ea22b2b01fd4a4cab39dc73e2e8c67"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d79f27c7872c130817d0783eb74385360c98a400cb08f02ec0991209e340b76"
    sha256 cellar: :any_skip_relocation, ventura:        "3d79f27c7872c130817d0783eb74385360c98a400cb08f02ec0991209e340b76"
    sha256 cellar: :any_skip_relocation, monterey:       "3d79f27c7872c130817d0783eb74385360c98a400cb08f02ec0991209e340b76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c450bb27a909106bf9c159317023c102c17cad776c4f947b5a435db1cae5d047"
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
