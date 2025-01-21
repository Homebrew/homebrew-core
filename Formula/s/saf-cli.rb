class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.17.tgz"
  sha256 "ca003e6453efac1b4c40e3ac63709cad76d9b6fe04269dacf14b2310373c5cc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be19818c032a7ecc50f0b895ffbb421fb7c2dd4f6d84e02523f09ef433b2c51e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be19818c032a7ecc50f0b895ffbb421fb7c2dd4f6d84e02523f09ef433b2c51e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be19818c032a7ecc50f0b895ffbb421fb7c2dd4f6d84e02523f09ef433b2c51e"
    sha256 cellar: :any_skip_relocation, sonoma:        "16dd13059f2ba1cf35528788552a8d2e455ae591c8ea543ff0f2532579017c95"
    sha256 cellar: :any_skip_relocation, ventura:       "16dd13059f2ba1cf35528788552a8d2e455ae591c8ea543ff0f2532579017c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be19818c032a7ecc50f0b895ffbb421fb7c2dd4f6d84e02523f09ef433b2c51e"
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
