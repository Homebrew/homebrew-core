class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.22.tgz"
  sha256 "4686e49d17dc6c1a11160dd2ffb069cce80af44b518a77e1983ec8f009735b07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed11ad01a48239ec19081277632e9286880b48d62569e012f7952ea1d07bbe26"
    sha256 cellar: :any,                 arm64_sequoia: "c6520a069786f4d6b8583a2738f1ded656a222a397a744c9c6557ddfb5ff31b4"
    sha256 cellar: :any,                 arm64_sonoma:  "c6520a069786f4d6b8583a2738f1ded656a222a397a744c9c6557ddfb5ff31b4"
    sha256 cellar: :any,                 arm64_ventura: "c6520a069786f4d6b8583a2738f1ded656a222a397a744c9c6557ddfb5ff31b4"
    sha256 cellar: :any,                 sonoma:        "e47c9751091879c5e7cfffbea996ba3d54228adfa74c8bfa50793d97718bab92"
    sha256 cellar: :any,                 ventura:       "e47c9751091879c5e7cfffbea996ba3d54228adfa74c8bfa50793d97718bab92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ea58435d04be976f0d76850798d61a320532818fcc12b6a56925b093e584126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "941541523dd33daab07bfd0470f08bada035552e525b89e67f22b3b46cb024b3"
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
