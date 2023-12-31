require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.3.0.tgz"
  sha256 "78e26e2ad96d2b52beb6e9f1419be6e2d9fb1ebfa57a6f6b685f1c49a81c248d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68f75a4d797721a1fdb0f1eabf5a57e20adec5542f542f308bf1ed192de6028b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68f75a4d797721a1fdb0f1eabf5a57e20adec5542f542f308bf1ed192de6028b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68f75a4d797721a1fdb0f1eabf5a57e20adec5542f542f308bf1ed192de6028b"
    sha256 cellar: :any_skip_relocation, sonoma:         "adf9075aaa0e9e0a168e45a5ae5dce726c67f779761576e2afd9de9aaaf7b731"
    sha256 cellar: :any_skip_relocation, ventura:        "adf9075aaa0e9e0a168e45a5ae5dce726c67f779761576e2afd9de9aaaf7b731"
    sha256 cellar: :any_skip_relocation, monterey:       "adf9075aaa0e9e0a168e45a5ae5dce726c67f779761576e2afd9de9aaaf7b731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c0e5701b849a4fddf31fd0f4d3a91ba6ac8ab053978fc119c2a3fdb1a6cb32"
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
