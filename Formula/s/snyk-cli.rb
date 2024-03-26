require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1286.1.tgz"
  sha256 "5d04b5565fe9039c3870fe4e94dff243a47b574a3c5a07665c265d5496fc0e98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0193ef6a790fd3cdb59c88191daba73c50cd7d7c3bd808389002a027a79bdedf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ba21a5ea12e6eb3e352714a4f01ba08377913eb17ae7864584763c4c5204a1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6966af2e61336663244626840b342ce03dc274a3922c1d502bd1dda8ab72b58f"
    sha256 cellar: :any_skip_relocation, sonoma:         "555fb5bc17536b72e750bfeac385796d51789e494eb376dc7aefa2d3ef83d0fb"
    sha256 cellar: :any_skip_relocation, ventura:        "1a3d55ff79665daf664231dbe7c01a3742776f62bd4da5c8512dc2285da065c4"
    sha256 cellar: :any_skip_relocation, monterey:       "c586efa535985bf0c2638b1d9b165e8f95bdc6b49bc6f0b1bf107bb66df49b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da57a33532fb78bf652c5bfc3285f44df93816516c0148170f2ff49a17718b46"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end
