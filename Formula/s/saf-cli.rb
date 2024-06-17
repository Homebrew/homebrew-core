require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.8.tgz"
  sha256 "7c4011463328a923781f3b7c26b148cb729bac4d0775f18ccad0560f5512b261"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a0a801bacbe9c3eddea579b29da27b80bc211e5d2ca3460741bcd592056cdb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a0a801bacbe9c3eddea579b29da27b80bc211e5d2ca3460741bcd592056cdb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a0a801bacbe9c3eddea579b29da27b80bc211e5d2ca3460741bcd592056cdb5"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b6481ba84453a56896575668891b1e433d10eed49751368f2818cfa979660a0"
    sha256 cellar: :any_skip_relocation, ventura:        "5b6481ba84453a56896575668891b1e433d10eed49751368f2818cfa979660a0"
    sha256 cellar: :any_skip_relocation, monterey:       "5b6481ba84453a56896575668891b1e433d10eed49751368f2818cfa979660a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e0efeca12b21ef67b20e426bc53e504d97266627e146f6dec033c999d9f6d8"
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
