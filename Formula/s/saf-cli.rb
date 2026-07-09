class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.6.0.tgz"
  sha256 "9d176c4c0caff994e70f1a32bebb4d81597cbff5d07b75f4257cdba2a6bd192c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0c8aa13b2a654ca00f4e30c627f564779e93c4bc027321284765ad3d1011b001"
    sha256 cellar: :any,                 arm64_sequoia: "ca3c608314c6a2f4b89a9e0f85e1b695ff45d9e2b353ea88c18eaf2f95f8a973"
    sha256 cellar: :any,                 arm64_sonoma:  "ca3c608314c6a2f4b89a9e0f85e1b695ff45d9e2b353ea88c18eaf2f95f8a973"
    sha256 cellar: :any,                 sonoma:        "a5d2b6bba9fb4150d2707fa31fcced0ac9505d32b4b770d8e462a14bc3406c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4788a6d127f4207085788fd6336a8bfcf88513cb6d7a04565e5169a28e7c64e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc2593cdd931a89da6879291e0aa23e72eea22b959e2c0dd93c74155dd6a447"
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
