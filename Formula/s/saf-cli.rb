class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.8.0.tgz"
  sha256 "0b2433ccc0a161176153f949a5c4b708686a83a4aeaf88216f211880574bfd98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "e3a3672273522e2919986b785a42f7b2ce536d7bbded2fb6d6cd217a26a032b7"
    sha256 cellar: :any,                 arm64_tahoe:       "e3a3672273522e2919986b785a42f7b2ce536d7bbded2fb6d6cd217a26a032b7"
    sha256 cellar: :any,                 arm64_sequoia:     "e3a3672273522e2919986b785a42f7b2ce536d7bbded2fb6d6cd217a26a032b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69e74713204d9a5f84dd98104354bf8814a9b2b23285435fd5f4cb98b69eb024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "18cb325cecff8e88e97be77ec3cfc4f2c51de9640ad23264f1a928c8f69c0f7e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/saf --version")

    output = shell_output("#{bin}/saf scan")
    assert_match "Visit https://saf.mitre.org/#/validate to explore and run inspec profiles", output
  end
end
