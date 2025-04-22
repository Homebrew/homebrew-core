class ReleaseIt < Formula
  desc "Generic CLI tool to automate versioning and package publishing related tasks"
  homepage "https://github.com/release-it/release-it"
  url "https://registry.npmjs.org/release-it/-/release-it-19.0.1.tgz"
  sha256 "2ac5268b16cf75f7be33c05c8e4b2cd47c2dfa4e8f43a308fca02f8ef5e09fd7"
  license "MIT"

  livecheck do
    url :homepage
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "529fe6dca9522cf3a767e0c99ff6f87c4dcff0f32cc3e2da2485237df991f0f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "529fe6dca9522cf3a767e0c99ff6f87c4dcff0f32cc3e2da2485237df991f0f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "529fe6dca9522cf3a767e0c99ff6f87c4dcff0f32cc3e2da2485237df991f0f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f62c6e50dc02056bbd49e1f95b34b33123244e0e32f33961367e22cdae954a27"
    sha256 cellar: :any_skip_relocation, ventura:       "f62c6e50dc02056bbd49e1f95b34b33123244e0e32f33961367e22cdae954a27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "529fe6dca9522cf3a767e0c99ff6f87c4dcff0f32cc3e2da2485237df991f0f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529fe6dca9522cf3a767e0c99ff6f87c4dcff0f32cc3e2da2485237df991f0f6"
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
