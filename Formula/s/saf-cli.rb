class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.5.1.tgz"
  sha256 "16709afef3d3cbc49260938f224f2e9dcae203c818b74215890d863557b278fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33d7d79ea6eb14571e99e8126e2a174a228b1b402a9be8a2f16ad96916fd0c21"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
