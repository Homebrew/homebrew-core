require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.1.tgz"
  sha256 "e5edac4106768fa748ae8bf11023a1fed2d02c454fa0e987b878b4fe3cf35bb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5f3f79edd76468b1f39a8b4bdb13dc59bd6e4f1f5c669a1cb0a34c4392e857f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5f3f79edd76468b1f39a8b4bdb13dc59bd6e4f1f5c669a1cb0a34c4392e857f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f3f79edd76468b1f39a8b4bdb13dc59bd6e4f1f5c669a1cb0a34c4392e857f"
    sha256 cellar: :any_skip_relocation, sonoma:         "03844bb723e164425f2bed2a5ba5e488ea37d127b5e998684003c76c951670c1"
    sha256 cellar: :any_skip_relocation, ventura:        "03844bb723e164425f2bed2a5ba5e488ea37d127b5e998684003c76c951670c1"
    sha256 cellar: :any_skip_relocation, monterey:       "03844bb723e164425f2bed2a5ba5e488ea37d127b5e998684003c76c951670c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f3f79edd76468b1f39a8b4bdb13dc59bd6e4f1f5c669a1cb0a34c4392e857f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
