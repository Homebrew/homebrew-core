require "language/node"

class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.2.32.tgz"
  sha256 "71c2a1c8eead8dde1aed2b682684503d2b66508a2dfe3dbf2027cbab21d82e28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ab0ebb8487e7d87622a7b2ec81ed93e92adcc7e3c6ec8b0f0e70332a5e85a88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ab0ebb8487e7d87622a7b2ec81ed93e92adcc7e3c6ec8b0f0e70332a5e85a88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ab0ebb8487e7d87622a7b2ec81ed93e92adcc7e3c6ec8b0f0e70332a5e85a88"
    sha256 cellar: :any_skip_relocation, sonoma:         "0231a0eff900937d28f49c38bf1adaf9c558d8f91097f6ab4c0ba046f4971a7d"
    sha256 cellar: :any_skip_relocation, ventura:        "0231a0eff900937d28f49c38bf1adaf9c558d8f91097f6ab4c0ba046f4971a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "0231a0eff900937d28f49c38bf1adaf9c558d8f91097f6ab4c0ba046f4971a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "192e62a1aa1e95612ff5ff40a7592dced4101c880c4540a66b90ddbe74d2db72"
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
