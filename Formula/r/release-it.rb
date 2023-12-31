require "language/node"

class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-17.0.1.tgz"
  sha256 "fede255bc1361877b294c8c76745957d88d5f5072031e537574afac4ecdaa43b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "857402fdbceaae67f1f686179cf2bd7f1d6c69d0f87fb55e24d99e556af31e8b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "857402fdbceaae67f1f686179cf2bd7f1d6c69d0f87fb55e24d99e556af31e8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "857402fdbceaae67f1f686179cf2bd7f1d6c69d0f87fb55e24d99e556af31e8b"
    sha256 cellar: :any_skip_relocation, sonoma:         "43a9aaf8da0ec08c5528ec31b19f633ee64b18a85bd6708f13b7808ef1a12aba"
    sha256 cellar: :any_skip_relocation, ventura:        "43a9aaf8da0ec08c5528ec31b19f633ee64b18a85bd6708f13b7808ef1a12aba"
    sha256 cellar: :any_skip_relocation, monterey:       "43a9aaf8da0ec08c5528ec31b19f633ee64b18a85bd6708f13b7808ef1a12aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "857402fdbceaae67f1f686179cf2bd7f1d6c69d0f87fb55e24d99e556af31e8b"
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
