class SafCli < Formula
  desc "CLI for the MITRE Security Automation Framework (SAF)"
  homepage "https://saf-cli.mitre.org"
  url "https://registry.npmjs.org/@mitre/saf/-/saf-1.4.11.tgz"
  sha256 "f4292e5e18bc0f8071c8f6e79aac4906a6e386438383200b045acdc041b0a7c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f54242a7274e3c7a66d41792821917f05494f21edaa83e754368cdc007dca7aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f54242a7274e3c7a66d41792821917f05494f21edaa83e754368cdc007dca7aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f54242a7274e3c7a66d41792821917f05494f21edaa83e754368cdc007dca7aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "eca47c1608c48bd0601113f976d5a5da85a76b967fdb73b5987c6f68e532628a"
    sha256 cellar: :any_skip_relocation, ventura:        "eca47c1608c48bd0601113f976d5a5da85a76b967fdb73b5987c6f68e532628a"
    sha256 cellar: :any_skip_relocation, monterey:       "eca47c1608c48bd0601113f976d5a5da85a76b967fdb73b5987c6f68e532628a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54242a7274e3c7a66d41792821917f05494f21edaa83e754368cdc007dca7aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
